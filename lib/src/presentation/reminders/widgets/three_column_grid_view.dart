import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_card.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class ThreeColumnGridView extends StatelessWidget {
  const ThreeColumnGridView({super.key, required this.reminders});

  final List<GameReminder> reminders;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: context.spacings.m),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 130,
          childAspectRatio: 0.75,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, index) {
            final reminder = reminders[index];
            return RepaintBoundary(
              child: GameCard(
                key: ValueKey(reminder.id),
                isVertical: true,
                reminder: reminder,
                onRemove: () {
                  context.read<RemindersCubit>().removeReminder(reminder.id);
                },
              ),
            );
          },
          childCount: reminders.length,
          addAutomaticKeepAlives: false,
          addRepaintBoundaries: false,
          findChildIndexCallback: (Key key) {
            if (key is ValueKey<int>) {
              final id = key.value;
              return reminders.indexWhere((reminder) => reminder.id == id);
            }
            return null;
          },
        ),
      ),
    );
  }
}
