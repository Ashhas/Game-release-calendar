import 'package:flutter/material.dart';

import 'package:game_release_calendar/main.dart';
import 'package:game_release_calendar/src/presentation/home/tabs/next_month_tab.dart';
import 'package:game_release_calendar/src/presentation/home/tabs/oncoming_month_tab.dart';
import 'package:game_release_calendar/src/presentation/home/tabs/this_month_tab.dart';

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
              Tab(text: 'THIS MONTH'),
              Tab(text: 'NEXT MONTH'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OncomingMonthTab(),
            ThisMonthTab(),
            NextMonthTab(),
          ],
        ),
      ),
    );
  }
}
