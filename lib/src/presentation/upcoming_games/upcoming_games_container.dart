import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/filter_bar/filter_bar.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class UpcomingGamesContainer extends StatelessWidget {
  const UpcomingGamesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        title: Row(
          children: [
            const Icon(Icons.event),
            SizedBox(width: context.spacings.m),
            const Text('Upcoming Games'),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: const [
          FilterBar(),
          GameList(),
        ],
      ),
    );
  }
}
