import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_ce/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/app.dart';
import 'package:game_release_calendar/src/config/env_config.dart';
import 'package:game_release_calendar/src/config/firebase_options.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository_impl.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/data/services/twitch_service.dart';
import 'package:game_release_calendar/src/data/services/game_update_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/utils/time_zone_mapper.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/hive_registrar.g.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  await _setupFirebase();
  await _initializeSharedPrefs(getIt);
  await _loadEnvVariables(getIt);
  await _initializeDio(getIt);
  await _initializeTwitchAuthService(getIt);
  await _initializeRepositories(getIt);
  await _initializeHive(getIt);
  await _initializeTimeZoneSettings();
  await _initializeNotificationService(getIt);
  await _initializeServices(getIt);

  runApp(
    const App(),
  );
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

Future<void> _initializeRepositories(GetIt getIt) async {
  getIt.registerSingleton<IGDBRepository>(
    IGDBRepositoryImpl(
      dio: getIt.get<Dio>(),
    ),
  );
}

Future<void> _initializeServices(GetIt getIt) async {
  getIt.registerSingleton<IGDBService>(
    IGDBService(
      repository: getIt.get<IGDBRepository>(),
    ),
  );

  final packageInfo = await PackageInfo.fromPlatform();
  getIt.registerSingleton<PackageInfo>(
    packageInfo,
  );

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
  const notificationIconSource = 'ic_game_pad';
  final notificationsPluginInstance = FlutterLocalNotificationsPlugin();

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

Future<void> _setupFirebase() async {
  final isAndroid = Platform.isAndroid;
  final isIOS = Platform.isIOS;
  final isMobile = isAndroid || isIOS;

  if (!isMobile) return;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  //
  // // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };
}
