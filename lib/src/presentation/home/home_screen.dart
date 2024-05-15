import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/home_container.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Release Calendar'),
      ),
      body: const HomeContainer(),
    );
  }
}
