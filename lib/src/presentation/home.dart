import 'package:flutter/material.dart';

import 'package:game_release_calendar/main.dart';
import 'package:game_release_calendar/src/presentation/oncoming_month_view.dart';
import 'package:game_release_calendar/src/presentation/this_month_view.dart';

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
              Tab(text: 'ONCOMING'),
              Tab(text: 'THIS MONTH VIEW'),
              Tab(text: 'THIS YEAR'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OncomingMonthView(),
            ThisMonthView(),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );
  }
}
