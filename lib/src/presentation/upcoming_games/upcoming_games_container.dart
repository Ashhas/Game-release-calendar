import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/filter_bar/filter_bar.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class UpcomingGamesContainer extends StatelessWidget {
  const UpcomingGamesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Row(
          children: [
            const Icon(Icons.event),
            SizedBox(width: context.spacings.m),
            const Text('Upcoming Games'),
          ],
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          FilterBar(),
          Expanded(
            child: BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
              builder: (_, state) {
                return state.games.when(
                  data: (games) => games.isEmpty
                      ? Center(child: Text('No games found'))
                      : GameList(
                          games: games,
                        ),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (error, _) => Center(child: Text('Error: $error')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
