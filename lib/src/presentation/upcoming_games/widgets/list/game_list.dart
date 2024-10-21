import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/section/day_section.dart';
import 'package:riverpod/riverpod.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
        builder: (_, state) {
          return state.games.when(
            data: (games) {
              return ListView.builder(
                itemCount: games.length,
                itemBuilder: (_, int index) {
                  final dayWithList = games.entries.elementAt(index);

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DaySection(
                        groupedGames: dayWithList,
                        key: ValueKey(dayWithList.key),
                      ),
                      const Divider(thickness: 1),
                    ],
                  );
                },
              );
            },
            loading: () {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
            error: (error, _) {
              return Center(
                child: Text(
                  'Error: $error',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
