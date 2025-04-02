part of '../reminders_container.dart';

class RemindersTab extends StatelessWidget {
  const RemindersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemindersCubit, RemindersState>(
      builder: (_, state) {
        final remindersList = state.reminders
            .sortedBy((reminder) => reminder.releaseDate.date ?? 0)
            .thenBy((reminder) => reminder.gameName);

        if (remindersList.isEmpty) {
          return Center(
            child: Text(
              'No reminders set',
            ),
          );
        }

        return ListView.builder(
          itemCount: remindersList.length,
          itemBuilder: (_, index) {
            final reminder = remindersList[index];
            return GameCard(reminder: reminder);
          },
        );
      },
    );
  }
}
