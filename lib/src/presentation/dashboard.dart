import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/more/more_container.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/upcoming_games_container.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<UpcomingGamesCubit>().getGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.event),
            label: 'Upcoming',
          ),
          NavigationDestination(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
        ],
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      ),
      body: [
        const UpcomingGamesContainer(),
        const MoreContainer(),
      ][_currentPageIndex],
    );
  }
}
