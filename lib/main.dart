import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/presentation/home.dart';
import 'package:game_release_calendar/src/services/igdb_service.dart';
import 'package:game_release_calendar/src/services/twitch_service.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.light,
      home: const Home(),
    );
  }
}
