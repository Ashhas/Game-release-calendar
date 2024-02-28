import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/presentation/home.dart';
import 'package:game_release_calendar/src/services/igdb_service.dart';
import 'package:game_release_calendar/src/services/twitch_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await TwitchAuthService().requestTokenAndStore();

  IGDBService(
    clientId: '',
  );

  runApp(
    const App(),
  );
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
