import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification_payload.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/app.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository_impl.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/data/services/twitch_service.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/enums/supported_game_platform.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/env_config.dart';
import 'package:game_release_calendar/src/utils/time_zone_mapper.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  await _initializeSharedPrefs(getIt);
  await _loadEnvVariables(getIt);
  await _initializeDio(getIt);
  await _initializeTwitchAuthService(getIt);
  await _initializeRepositories(getIt);
  await _initializeServices(getIt);
  await _initializeHive(getIt);
  await _initializeTimeZoneSettings();
  await _initializeNotificationService(getIt);

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
      requestHeader: true,
      requestBody: true,
      responseBody: false,
      responseHeader: true,
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
}

Future<void> _initializeHive(GetIt getIt) async {
  Directory directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(GameAdapter());
  Hive.registerAdapter(PlatformAdapter());
  Hive.registerAdapter(CoverAdapter());
  Hive.registerAdapter(ReleaseDateAdapter());
  Hive.registerAdapter(ReleaseDateCategoryAdapter());
  Hive.registerAdapter(SupportedGamePlatformAdapter());
  Hive.registerAdapter(ScheduledNotificationPayloadAdapter());

  final Box<Game> box = await Hive.openBox<Game>('game_bookmark_box');
  getIt.registerSingleton<Box<Game>>(
    box,
  );

  // final box = await Hive.openBox<ScheduledNotificationPayload>(
  //   'game_scheduled_box',
  // );
  // getIt.registerSingleton<Box<ScheduledNotificationPayload>>(
  //   box,
  // );
}

Future<void> _initializeNotificationService(GetIt getIt) async {
  const notificationIconSource = 'ic_game_pad';
  final notificationsPluginInstance = FlutterLocalNotificationsPlugin();

  const initializationSettingsAndroid = AndroidInitializationSettings(
    notificationIconSource,
  );
  const initializationSettingsIOS = DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  const initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  await notificationsPluginInstance.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (_) {},
  );

  // Request permissions for Android
  notificationsPluginInstance
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  getIt.registerSingleton<FlutterLocalNotificationsPlugin>(
    notificationsPluginInstance,
  );
  getIt.registerSingleton<NotificationClient>(
    NotificationClient(),
  );
}

Future<void> _initializeTimeZoneSettings() async {
  final currentTimeZone = await FlutterTimezone.getLocalTimezone();
  final timeZoneName = TimeZoneMapper.getTzLocation(currentTimeZone);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}
