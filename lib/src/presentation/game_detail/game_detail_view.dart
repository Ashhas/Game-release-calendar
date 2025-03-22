import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:intl/intl.dart';
import 'package:spaced_flex/spaced_flex.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';
import 'package:game_release_calendar/src/utils/url_helper.dart';

part 'widgets/game_info.dart';

part 'widgets/game_toolbar.dart';

class GameDetailView extends StatefulWidget {
  const GameDetailView({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  bool _isScheduled = context.read<RemindersCubit>().isGameScheduled(
    widget.game.id,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.all(context.spacings.m),
        child: SpacedColumn(
          spacing: context.spacings.m,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            GameInfo(game: widget.game),
            const Divider(),
            GameToolbar(game: widget.game),
          ],
        ),
      ),
    );
  }
}
