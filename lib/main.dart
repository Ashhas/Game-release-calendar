import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/firebase_options.dart';
import 'package:game_release_calendar/hive_registrar.g.dart';
import 'package:game_release_calendar/src/app.dart';
import 'package:game_release_calendar/src/config/env_config.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository_impl.dart';
import 'package:game_release_calendar/src/data/services/analytics_service.dart';
import 'package:game_release_calendar/src/data/services/game_update_service.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/data/services/twitch_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/utils/time_zone_mapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase first (required for Crashlytics)
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    if (kDebugMode) {
      debugPrint('Firebase: Initialized successfully');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint(
        'Firebase: Initialization failed - crash reporting will be disabled',
      );
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
    // Continue without Firebase - app can still function
  }

  final getIt = GetIt.instance;

  // Phase 1: Parallel initialization of independent tasks
  // These complete before Phase 2, which depends on their GetIt registrations
  final packageInfoFuture =
      PackageInfo.fromPlatform(); // Awaited separately to capture result
  await Future.wait([
    _initializeSharedPrefs(getIt),
    _loadEnvVariables(getIt),
    _initializeHive(getIt),
    _initializeTimeZoneSettings(),
  ]);

  // Register PackageInfo (awaited separately to get the result)
  final packageInfo = await packageInfoFuture;
  getIt.registerSingleton<PackageInfo>(packageInfo);

  // Phase 2: Initialize networking (depends on env config)
  await _initializeDio(getIt);
  await _initializeTwitchAuthService(getIt);
  _addAuthRetryInterceptor(getIt); // Add 401 retry after auth service exists

  // Phase 3: Initialize remaining services (depends on networking + Hive)
  await _initializeRepositories(getIt);
  await _initializeNotificationService(getIt);
  await _initializeServices(getIt);

  // Phase 4: Non-critical analytics and crash reporting (can fail without breaking app)
  await _initializePostHog(getIt);
  await _initializeCrashlytics(getIt);

  runApp(PostHogWidget(child: const App()));
}

Future<void> _initializePostHog(GetIt getIt) async {
  // Skip analytics entirely in debug/development mode
  if (kDebugMode) {
    debugPrint('PostHog: Disabled in debug mode');
    return;
  }

  final sharedPrefs = getIt.get<SharedPrefsService>();

  // GDPR: Only initialize if user has given explicit consent
  if (!sharedPrefs.getAnalyticsConsent()) {
    if (kDebugMode) {
      debugPrint('PostHog: User has not consented to analytics');
    }
    return;
  }

  await _setupPostHog(getIt);
}

/// Sets up PostHog analytics. Called after user consent is given.
/// Can be called from settings when user enables analytics.
Future<void> _setupPostHog(GetIt getIt) async {
  try {
    final envConfig = getIt.get<EnvConfig>();
    final packageInfo = getIt.get<PackageInfo>();
    final sharedPrefs = getIt.get<SharedPrefsService>();

    // Skip initialization if API key is not configured
    if (envConfig.posthogApiKey.isEmpty) {
      if (kDebugMode) {
        debugPrint('PostHog: API key not configured, analytics disabled');
      }
      return;
    }

    // Configure PostHog analytics (privacy-focused, no session replay)
    final config = PostHogConfig(envConfig.posthogApiKey);
    config.host = envConfig.posthogHost;
    config.debug = false;
    config.captureApplicationLifecycleEvents = true;
    config.sessionReplay = false; // Disabled for GDPR compliance
    config.personProfiles =
        PostHogPersonProfiles.never; // Anonymous events only

    await Posthog().setup(config);

    // Register super properties - automatically included with every event
    final posthog = Posthog();
    await posthog.register('app_version', packageInfo.version);
    await posthog.register('build_number', packageInfo.buildNumber);
    await posthog.register('platform', Platform.operatingSystem);
    await posthog.register('theme_color', sharedPrefs.getColorPreset().name);
    await posthog.register(
      'theme_brightness',
      sharedPrefs.getBrightnessPreset().name,
    );

    if (kDebugMode) {
      debugPrint('PostHog: Analytics initialized successfully');
    }
  } catch (e, stackTrace) {
    // Analytics is non-critical - log error but allow app to continue
    if (kDebugMode) {
      debugPrint(
        'PostHog: Initialization failed - analytics disabled for this session',
      );
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

/// Initializes PostHog after user gives consent. Call from consent dialog.
/// Returns true if initialization succeeded.
Future<bool> initializePostHogAfterConsent() async {
  if (kDebugMode) return false;
  try {
    await _setupPostHog(GetIt.instance);
    return true;
  } catch (e) {
    // Error logging already handled in _setupPostHog
    return false;
  }
}

Future<void> _initializeCrashlytics(GetIt getIt) async {
  // Skip crash reporting in debug mode
  if (kDebugMode) {
    debugPrint('Crashlytics: Disabled in debug mode');
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    return;
  }

  final sharedPrefs = getIt.get<SharedPrefsService>();

  // GDPR: Only enable if user has given explicit consent
  if (!sharedPrefs.getCrashLogsConsent()) {
    if (kDebugMode) {
      debugPrint('Crashlytics: User has not consented to crash logs');
    }
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    return;
  }

  await _setupCrashlytics();
}

/// Sets up Firebase Crashlytics. Called after user consent is given.
Future<void> _setupCrashlytics() async {
  try {
    // Enable crash collection
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Pass all uncaught "fatal" errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass all uncaught asynchronous errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    if (kDebugMode) {
      debugPrint('Crashlytics: Crash reporting initialized successfully');
    }
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('Crashlytics: Initialization failed');
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}

/// Initializes Crashlytics after user gives consent.
/// Returns true if initialization succeeded.
Future<bool> initializeCrashlyticsAfterConsent() async {
  if (kDebugMode) return false;
  try {
    await _setupCrashlytics();
    return true;
  } catch (e) {
    // Error logging already handled in _setupCrashlytics
    return false;
  }
}

/// Disables Crashlytics when user revokes consent.
/// Returns true if successfully disabled.
Future<bool> disableCrashlytics() async {
  try {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
    if (kDebugMode) {
      debugPrint('Crashlytics: Crash reporting disabled');
    }
    return true;
  } catch (e, stackTrace) {
    if (kDebugMode) {
      debugPrint('Crashlytics: Failed to disable crash reporting');
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
    return false;
  }
}

Future<void> _initializeSharedPrefs(GetIt getIt) async {
  await SharedPrefsService.init();
  getIt.registerSingleton<SharedPrefsService>(SharedPrefsService());
}

Future<void> _loadEnvVariables(GetIt getIt) async {
  final jsonString = await rootBundle.loadString('env/env.json');
  final mapString = jsonDecode(jsonString);

  getIt.registerSingleton<EnvConfig>(EnvConfig(mapString));
}

Future<void> _initializeTwitchAuthService(GetIt getIt) async {
  final envConfig = getIt.get<EnvConfig>();

  getIt.registerSingleton<TwitchAuthService>(
    await TwitchAuthService.create(
      dio: getIt.get<Dio>(),
      clientId: envConfig.twitchClientId,
      clientSecret: envConfig.twitchClientSecret,
      twitchOauthTokenURL: envConfig.igdbAuthTokenURL,
    ),
  );
}

Future<void> _initializeDio(GetIt getIt) async {
  final envConfig = getIt.get<EnvConfig>();

  final dio = Dio(
    BaseOptions(
      baseUrl: envConfig.igdbBaseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {'Client-ID': envConfig.twitchClientId},
    ),
  );
  dio.interceptors.add(
    PrettyDioLogger(
      requestHeader: false,
      requestBody: true,
      responseBody: false,
      responseHeader: false,
      error: true,
      compact: true,
      maxWidth: 100,
    ),
  );
  getIt.registerSingleton<Dio>(dio);
}

/// Adds an interceptor to automatically refresh token on 401 errors.
///
/// This handles token expiry gracefully by refreshing and retrying the request.
void _addAuthRetryInterceptor(GetIt getIt) {
  final dio = getIt.get<Dio>();
  final authService = getIt.get<TwitchAuthService>();

  dio.interceptors.add(
    InterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode != 401) {
          return handler.next(error);
        }

        if (kDebugMode) {
          debugPrint('Auth: Token expired, attempting refresh...');
        }

        final refreshed = await authService.refreshToken();

        if (!refreshed) {
          if (kDebugMode) {
            debugPrint('Auth: Token refresh failed, cannot retry request');
          }
          return handler.next(error);
        }

        if (kDebugMode) {
          debugPrint('Auth: Token refreshed, retrying request');
        }

        try {
          final retryResponse = await dio.fetch(error.requestOptions);
          return handler.resolve(retryResponse);
        } catch (retryError) {
          if (kDebugMode) {
            debugPrint('Auth: Retry failed after token refresh - $retryError');
          }
          return handler.next(error);
        }
      },
    ),
  );
}

Future<void> _initializeRepositories(GetIt getIt) async {
  getIt.registerSingleton<IGDBRepository>(
    IGDBRepositoryImpl(dio: getIt.get<Dio>()),
  );
}

Future<void> _initializeServices(GetIt getIt) async {
  getIt.registerSingleton<AnalyticsService>(AnalyticsService());

  getIt.registerSingleton<IGDBService>(
    IGDBService(repository: getIt.get<IGDBRepository>()),
  );

  // Note: PackageInfo is registered earlier in main() for parallel initialization

  getIt.registerSingleton<GameUpdateService>(
    GameUpdateService(
      igdbRepository: getIt.get<IGDBRepository>(),
      gameRemindersBox: getIt.get<Box<GameReminder>>(),
      notificationClient: getIt.get<NotificationClient>(),
      gameUpdateLogBox: getIt.get<Box<GameUpdateLog>>(),
    ),
  );
}

Future<void> _initializeHive(GetIt getIt) async {
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapters();

  final Box<Game> gameBox = await Hive.openBox<Game>('game_bookmark_box');
  getIt.registerSingleton<Box<Game>>(gameBox);

  final box = await Hive.openBox<GameReminder>('game_scheduled_box');
  getIt.registerSingleton<Box<GameReminder>>(box);

  final gameUpdateLogBox = await Hive.openBox<GameUpdateLog>(
    'game_updates_log_box',
  );
  getIt.registerSingleton<Box<GameUpdateLog>>(gameUpdateLogBox);
}

Future<void> _initializeNotificationService(GetIt getIt) async {
  final notificationsPluginInstance = FlutterLocalNotificationsPlugin();

  try {
    const notificationIconSource = 'ic_game_pad';

    const initializationSettingsAndroid = AndroidInitializationSettings(
      notificationIconSource,
    );
    const initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await notificationsPluginInstance.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (_) {},
    );

    // Create notification channel for Android
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'release_day_channel',
      'Game Release Notifications',
      description: 'Notifications for game release days',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
      showBadge: true,
      enableLights: true,
      ledColor: Color(0xFF819FC3),
    );

    final androidPlugin = notificationsPluginInstance
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin != null) {
      // Create the notification channel
      await androidPlugin.createNotificationChannel(channel);

      // Request notification permissions
      await androidPlugin.requestNotificationsPermission();

      // Request exact alarm permission for Android 12+
      await androidPlugin.requestExactAlarmsPermission();
    }

    if (kDebugMode) {
      debugPrint('Notifications: Initialized successfully');
    }
  } catch (e, stackTrace) {
    // Notification setup is non-critical - app should still work without it
    if (kDebugMode) {
      debugPrint(
        'Notifications: Initialization failed - notifications disabled',
      );
      debugPrint('Error: $e');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
    notificationsPluginInstance,
  );

  final notificationClient = NotificationClient();
  getIt.registerSingleton<NotificationClient>(notificationClient);

  getIt.registerSingleton<NotificationsCubit>(
    NotificationsCubit(notificationClient: notificationClient),
  );
}

Future<void> _initializeTimeZoneSettings() async {
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  final timeZoneName = TimeZoneMapper.getTzLocation(currentTimeZone);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
