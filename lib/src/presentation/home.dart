import 'package:flutter/material.dart';
import 'package:game_release_calendar/main.dart';
import 'package:game_release_calendar/src/models/game.dart';
import 'package:game_release_calendar/src/presentation/month_view.dart';
import 'package:game_release_calendar/src/services/igdb_service.dart';

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(App.appName),
          bottom: const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: 'THIS MONTH'),
              Tab(text: 'COMING 3 MONTHS'),
              Tab(text: 'THIS YEAR'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            MonthView(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
