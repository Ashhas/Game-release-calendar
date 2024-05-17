import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/section/day_section.dart';
import 'package:game_release_calendar/src/theme/context_extensions.dart';
import 'package:game_release_calendar/src/utils/filter_functions.dart';

part '../upcoming_games/widgets/tabs/this_month_tab.dart';

part '../upcoming_games/widgets/tabs/next_month_tab.dart';

part '../upcoming_games/widgets/tabs/this_year_tab.dart';

class UpcomingGamesContainer extends StatelessWidget {
  const UpcomingGamesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                title: Row(
                  children: [
                    const Icon(Icons.event),
                    SizedBox(width: context.spacings.xs),
                    const Text('Upcoming Games'),
                  ],
                ),
                floating: true,
                pinned: true,
                bottom: const TabBar(
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  tabs: [
                    Tab(text: 'This Month'),
                    Tab(text: 'Next Month'),
                    Tab(text: 'This Year'),
                  ],
                ),
              ),
            ];
          },
          body: const TabBarView(
            children: [
              ThisMonthTab(),
              NextMonthTab(),
              ThisYearTab(),
            ],
          ),
        ),
      ),
    );
  }
}
