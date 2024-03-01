import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/game_tile.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/section/section_header.dart';

class DaySection extends StatelessWidget {
  final MapEntry<DateTime, List<Game>> groupedGames;

  const DaySection({
    required this.groupedGames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(date: groupedGames.key),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: groupedGames.value
              .map(
                (game) => GameTile(
                  game: game,
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
