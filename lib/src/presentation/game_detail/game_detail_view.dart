import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/convert_functions.dart';
import 'package:game_release_calendar/src/utils/url_launch_functions.dart';

import 'package:spaced_flex/spaced_flex.dart';

part 'widgets/game_info.dart';

part 'widgets/icon_row.dart';

class GameDetailView extends StatefulWidget {
  final Game game;

  const GameDetailView({
    required this.game,
    super.key,
  });

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(context.spacings.m),
        child: SpacedColumn(
          spacing: context.spacings.m,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GameInfo(game: widget.game),
            const Divider(),
            IconRow(game: widget.game),
          ],
        ),
      ),
    );
  }
}
