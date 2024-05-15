import 'package:flutter/material.dart';

import 'package:game_release_calendar/main.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/home_container.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(App.appName),
      ),
      body: const HomeContainer(),
    );
  }
}
