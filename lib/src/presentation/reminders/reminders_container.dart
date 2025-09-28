import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/utils/release_date_comparator.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/list/reminder_list_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/two_column_grid_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/three_column_grid_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/view_toggle_tab.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';
import '../../domain/models/notifications/game_reminder.dart';

part 'widgets/game_reminder_tile.dart';

part 'notifications_container.dart';

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
                  MaterialPageRoute(builder: (_) => const NotificationsContainer()));
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
                ViewToggleTab(
                  selectedIndex: state.reminderViewIndex,
                ),
                SizedBox(height: context.spacings.xs),
                if (state.reminderViewIndex == 0)
                  TwoColumnGridView(reminders: remindersList),
                if (state.reminderViewIndex == 1)
                  ThreeColumnGridView(reminders: remindersList),
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
