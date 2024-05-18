import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:game_release_calendar/src/app.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository_impl.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/twitch_service.dart';
import 'package:game_release_calendar/src/utils/env_config.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final getIt = GetIt.instance;

  await _loadEnvVariables(getIt);
  await _initializeTwitchAuthService(getIt);
  await _initializeDio(getIt);
  await _initializeRepositories(getIt);
  await _initializeServices(getIt);

  runApp(
    const App(),
  );
}

Future<void> _loadEnvVariables(GetIt getIt) async {
  final jsonString = await rootBundle.loadString('env/env.json');
  final mapString = jsonDecode(jsonString);

  getIt.registerSingleton<EnvConfig>(EnvConfig(mapString));
}

Future<void> _initializeTwitchAuthService(GetIt getIt) async {
  final envConfig = getIt.get<EnvConfig>();

  getIt.registerSingleton<TwitchAuthService>(
    TwitchAuthService(
      clientId: envConfig.twitchClientId,
      clientSecret: envConfig.twitchClientSecret,
      twitchOauthTokenURL: envConfig.igdbAuthTokenURL,
    ),
  );
  await getIt.get<TwitchAuthService>().requestTokenAndStore();
}

Future<void> _initializeDio(GetIt getIt) async {
  final envConfig = getIt.get<EnvConfig>();

  final igdbAccessToken = await getIt.get<TwitchAuthService>().getStoredToken();
  final dio = Dio(
    BaseOptions(
      baseUrl: envConfig.igdbBaseUrl,
      headers: {
        'Client-ID': envConfig.twitchClientId,
        'Authorization': 'Bearer $igdbAccessToken',
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
