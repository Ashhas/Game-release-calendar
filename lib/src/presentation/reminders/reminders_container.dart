import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/utils/release_date_comparator.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_card.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/list/reminder_list_view.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';
import '../../domain/models/notifications/game_reminder.dart';

part 'widgets/game_reminder_tile.dart';

part 'tabs/notifications_tab.dart';

class RemindersContainer extends StatefulWidget {
  const RemindersContainer({super.key});

  @override
  State<RemindersContainer> createState() => _RemindersContainerState();
}

class _RemindersContainerState extends State<RemindersContainer> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().loadGames();
    context.read<RemindersCubit>().getPreferredDataView();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Reminders'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const NotificationsTab()));
            },
            icon: Icon(Icons.textsms_outlined),
          ),
          Padding(
            padding: EdgeInsets.only(
              right: context.spacings.xs,
            ),
          )
        ],
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (_, state) {
          final remindersList = state.reminders
              .sortedBy((reminder) =>
                  ReleaseDateComparator.getSortableTimestamp(
                      reminder.releaseDate.date))
              .thenBy((reminder) => reminder.gameName);

          if (remindersList.isEmpty) {
            return const Center(
              child: Text('No reminders set'),
            );
          }

          return SingleChildScrollView(
            padding: EdgeInsets.only(bottom: context.spacings.s),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
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
                    Theme.of(context).colorScheme.tertiary,
                  ],
                  unSelectedBackgroundColors: [
                    Theme.of(context).colorScheme.surfaceContainerLow,
                  ],
                  selectedTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  unSelectedTextStyle: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
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
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onRemove: () {
                          context
                              .read<RemindersCubit>()
                              .removeReminder(reminder.id);
                        },
                      );
                    },
                  ),
                if (state.reminderViewIndex == 1)
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                        onRemove: () {
                          context
                              .read<RemindersCubit>()
                              .removeReminder(reminder.id);
                        },
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
      ),
    );
  }
}
