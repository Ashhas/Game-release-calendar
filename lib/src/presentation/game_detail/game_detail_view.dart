import 'package:flutter/material.dart';

import 'package:spaced_flex/spaced_flex.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/convert_functions.dart';
import 'package:game_release_calendar/src/utils/url_launch_functions.dart';

part 'widgets/game_info.dart';

part 'widgets/icon_row.dart';

class GameDetailView extends StatelessWidget {
  const GameDetailView({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Padding(
        padding: EdgeInsets.all(context.spacings.m),
        child: SpacedColumn(
          spacing: context.spacings.m,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GameInfo(game: game),
            const Divider(),
            IconRow(game: game),
          ],
        ),
      ),
    );
  }
}
