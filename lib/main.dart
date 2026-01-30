import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';
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

  final getIt = GetIt.instance;

  // Phase 1: Parallel initialization of independent tasks
  // These complete before Phase 2, which depends on their GetIt registrations
  final packageInfoFuture = PackageInfo.fromPlatform(); // Awaited separately to capture result
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

  // Phase 4: Non-critical analytics (can fail without breaking app)
  await _initializePostHog(getIt);

  runApp(
    PostHogWidget(
      child: const App(),
    ),
  );
}

Future<void> _initializePostHog(GetIt getIt) async {
  // Skip analytics entirely in debug/development mode
  if (kDebugMode) {
    debugPrint('PostHog: Disabled in debug mode');
    return;
  }

  try {
    final envConfig = getIt.get<EnvConfig>();
    final packageInfo = getIt.get<PackageInfo>();
    final sharedPrefs = getIt.get<SharedPrefsService>();

    // Skip initialization if API key is not configured
    if (envConfig.posthogApiKey.isEmpty) {
      debugPrint('PostHog: API key not configured, analytics disabled');
      return;
    }

    // Configure PostHog analytics
    final config = PostHogConfig(envConfig.posthogApiKey);
    config.host = envConfig.posthogHost;
    config.debug = false; // Never log in production
    config.captureApplicationLifecycleEvents = true;

    // Enable session replay to understand user behavior and reproduce issues
    config.sessionReplay = true;
    config.sessionReplayConfig.maskAllTexts = false;
    config.sessionReplayConfig.maskAllImages = false;

    await Posthog().setup(config);

    // Register super properties - automatically included with every event
    final posthog = Posthog();
    await posthog.register('app_version', packageInfo.version);
    await posthog.register('build_number', packageInfo.buildNumber);
    await posthog.register('platform', Platform.operatingSystem);
    await posthog.register('theme_color', sharedPrefs.getColorPreset().name);
    await posthog.register('theme_brightness', sharedPrefs.getBrightnessPreset().name);

    debugPrint('PostHog: Analytics initialized successfully');
  } catch (e, stackTrace) {
    // Analytics is non-critical - log error but allow app to continue
    debugPrint('PostHog: Initialization failed - analytics disabled for this session');
    debugPrint('Error: $e');
    debugPrintStack(stackTrace: stackTrace);
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
      headers: {
        'Client-ID': envConfig.twitchClientId,
      },
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
        if (error.response?.statusCode == 401) {
          debugPrint('Auth: Token expired, attempting refresh...');

          final refreshed = await authService.refreshToken();

          if (refreshed) {
            debugPrint('Auth: Token refreshed, retrying request');
            try {
              final retryResponse = await dio.fetch(error.requestOptions);
              return handler.resolve(retryResponse);
            } catch (retryError) {
              debugPrint('Auth: Retry failed after token refresh - $retryError');
              return handler.next(error);
            }
          } else {
            debugPrint('Auth: Token refresh failed, cannot retry request');
          }
        }
        return handler.next(error);
      },
    ),
  );
}

Future<void> _initializeRepositories(GetIt getIt) async {
  getIt.registerSingleton<IGDBRepository>(
    IGDBRepositoryImpl(
      dio: getIt.get<Dio>(),
    ),
  );
}

Future<void> _initializeServices(GetIt getIt) async {
  getIt.registerSingleton<AnalyticsService>(AnalyticsService());

  getIt.registerSingleton<IGDBService>(
    IGDBService(
      repository: getIt.get<IGDBRepository>(),
    ),
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
  getIt.registerSingleton<Box<Game>>(
    gameBox,
  );

  final box = await Hive.openBox<GameReminder>(
    'game_scheduled_box',
  );
  getIt.registerSingleton<Box<GameReminder>>(
    box,
  );

  final gameUpdateLogBox = await Hive.openBox<GameUpdateLog>(
    'game_updates_log_box',
  );
  getIt.registerSingleton<Box<GameUpdateLog>>(
    gameUpdateLogBox,
  );
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
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin != null) {
      // Create the notification channel
      await androidPlugin.createNotificationChannel(channel);

      // Request notification permissions
      await androidPlugin.requestNotificationsPermission();

      // Request exact alarm permission for Android 12+
      await androidPlugin.requestExactAlarmsPermission();
    }

    debugPrint('Notifications: Initialized successfully');
  } catch (e, stackTrace) {
    // Notification setup is non-critical - app should still work without it
    debugPrint('Notifications: Initialization failed - notifications disabled');
    debugPrint('Error: $e');
    debugPrintStack(stackTrace: stackTrace);
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
