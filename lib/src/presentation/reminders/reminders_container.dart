import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

part 'widgets/game_reminder_tile.dart';

class RemindersContainer extends StatefulWidget {
  const RemindersContainer({super.key});

  @override
  State<RemindersContainer> createState() => _RemindersContainerState();
}

class _RemindersContainerState extends State<RemindersContainer> {
  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().retrievePendingNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Reminders'),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: BlocBuilder<RemindersCubit, RemindersState>(
        builder: (_, state) {
          return state.reminders.when(
            data: (remindersList) {
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
                  return GameReminderTile(reminder: reminder);
                },
              );
            },
            error: (err, _) => Center(
              child: Text(
                'Error: $err',
              ),
            ),
            loading: () => CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
