import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/convert_functions.dart';

part 'section/day_section.dart';

part 'section/section_header.dart';

part 'game_tile/game_tile.dart';

class GameList extends StatelessWidget {
  const GameList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
        builder: (_, state) {
          return state.games.when(
            data: (games) => ListView.separated(
              itemCount: games.length,
              separatorBuilder: (_, __) => const Divider(thickness: 1),
              itemBuilder: (_, index) => DaySection(
                groupedGames: games.entries.elementAt(index),
                key: ValueKey(games.entries.elementAt(index).key),
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Center(child: Text('Error: $error')),
          );
        },
      ),
    );
  }
}
