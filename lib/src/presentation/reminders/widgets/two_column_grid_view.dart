import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_card.dart';

class TwoColumnGridView extends StatelessWidget {
  const TwoColumnGridView({
    super.key,
    required this.reminders,
  });

  final List<GameReminder> reminders;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75, // 108w/144h from Figma
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: reminders.length,
      itemBuilder: (_, index) {
        final reminder = reminders[index];
        return GameCard(
          isVertical: true,
          reminder: reminder,
          onRemove: () {
            context.read<RemindersCubit>().removeReminder(reminder.id);
          },
        );
      },
    );
  }
}