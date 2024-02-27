import 'package:flutter/material.dart';
import 'package:game_release_calendar/presentation/home.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  static const appName = 'Shinbun';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      themeMode: ThemeMode.dark,
      home: const Home(),
    );
  }
}
