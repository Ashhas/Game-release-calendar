import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/utils/env_config.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository_impl.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/services/twitch_service.dart';
import 'package:game_release_calendar/src/presentation/home/home_screen.dart';
import 'package:game_release_calendar/src/presentation/home/state/home_cubit.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadEnvVariables();
  await _initializeServices();

  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Game Release Calendar',
      theme: CustomTheme.lightTheme(),
      darkTheme: CustomTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(
            create: (BuildContext context) => HomeCubit(
              igdbService: IGDBService.instance,
            ),
          ),
        ],
        child: const Home(),
      ),
    );
  }
}

Future<void> loadEnvVariables() async {
  final jsonString = await rootBundle.loadString('assets/env.json');
  final mapString = jsonDecode(jsonString);

  EnvConfig().setEnv(mapString);
}

Future<void> _initializeServices() async {
  final envConfig = EnvConfig().envMap;

  await TwitchAuthService(
    clientId: envConfig['twitchClientId'] ?? '',
    clientSecret: envConfig['twitchClientSecret'] ?? '',
    twitchOauthTokenURL: envConfig['igdbAuthTokenURL'] ?? '',
  ).requestTokenAndStore();

  IGDBService(
    repository: IGDBRepositoryImpl(
      clientId: envConfig['twitchClientId'] ?? '',
      igdbBaseUrl: envConfig['igdbBaseUrl'] ?? '',
    ),
  );
}
