part of '../reminders_container.dart';

class RemindersTab extends StatefulWidget {
  const RemindersTab({super.key});

  @override
  State<RemindersTab> createState() => _RemindersTabState();
}

class _RemindersTabState extends State<RemindersTab> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().getPreferredDataView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RemindersCubit, RemindersState>(
      builder: (_, state) {
        final remindersList = state.reminders
            .sortedBy((reminder) => reminder.releaseDate.date ?? 0)
            .thenBy((reminder) => reminder.gameName);

        if (remindersList.isEmpty) {
          return const Center(
            child: Text('No reminders set'),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.only(bottom: context.spacings.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlutterToggleTab(
                width: 35,
                borderRadius: 12,
                dataTabs: [
                  DataTab(
                    icon: Icons.grid_view,
                  ),
                  DataTab(
                    icon: Icons.grid_on,
                  ),
                  DataTab(
                    icon: Icons.list,
                  ),
                ],
                selectedBackgroundColors: [
                  Colors.white,
                ],
                selectedIndex: state.reminderViewIndex,
                selectedLabelIndex: (index) {
                  setState(() {
                    context.read<RemindersCubit>().storePreferredDataView(
                      index,
                    );
                  });
                },
              ),
              SizedBox(height: context.spacings.xs),
              if (state.reminderViewIndex == 0)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: remindersList.length,
                  itemBuilder: (_, index) {
                    final reminder = remindersList[index];
                    return GameCard(
                      isVertical: true,
                      reminder: reminder,
                    );
                  },
                ),
              if (state.reminderViewIndex == 1)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.7,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: remindersList.length,
                  itemBuilder: (_, index) {
                    final reminder = remindersList[index];
                    return GameCard(
                      isVertical: true,
                      reminder: reminder,
                    );
                  },
                ),
              if (state.reminderViewIndex == 2)
                RemindersListView(
                  reminders: GameDateGrouper.groupRemindersByReleaseDate(
                    remindersList,
                  ),
                )
            ],
          ),
        );
      },
    );
  }
}
