import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

part 'section/day_section.dart';

part 'section/section_header.dart';

part 'game_tile/game_tile.dart';

class GameList extends StatefulWidget {
  const GameList({
    required this.games,
    super.key,
  });

  final Map<DateTime, List<Game>> games;

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  @override
  Widget build(BuildContext context) {
    final entries = widget.games.entries.toList();

    return CustomScrollView(
      shrinkWrap: true,
      slivers: [
        if (entries.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No games found')),
          )
        else
          for (var entry in entries)
            DaySection(
              groupedGames: entry,
              key: ValueKey(entry.key),
            ),
      ],
    );
  }
}
