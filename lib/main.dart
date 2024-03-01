import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

import 'package:game_release_calendar/src/data/igdb_service.dart';
import 'package:game_release_calendar/src/data/twitch_service.dart';
import 'package:game_release_calendar/src/presentation/home/home.dart';
import 'package:game_release_calendar/src/theme/custom_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final envMap = await loadEnvVariables();

  final twitchAuthService = TwitchAuthService(
    clientId: envMap['twitchClientId'] ?? '',
    clientSecret: envMap['twitchClientSecret'] ?? '',
    twitchOauthTokenURL: envMap['igdbAuthTokenURL'] ?? '',
  );
  await twitchAuthService.requestTokenAndStore();

  IGDBService(
    clientId: envMap['twitchClientId'] ?? '',
    authTokenURL: envMap['igdbBaseUrl'] ?? '',
  );

  runApp(
    const App(),
  );
}

Future<dynamic> loadEnvVariables() async {
  final jsonString = await rootBundle.loadString('assets/env.json');
  return jsonDecode(jsonString);
}

class App extends StatelessWidget {
  const App({
    super.key,
  });

  static const appName = 'Game Release';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: CustomTheme.lightTheme(),
      darkTheme: CustomTheme.darkTheme(),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}
