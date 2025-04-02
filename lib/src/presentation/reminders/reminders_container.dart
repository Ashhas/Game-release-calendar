import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';

import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';

import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:intl/intl.dart';
import 'package:riverpod/riverpod.dart';

import '../../domain/models/notifications/game_reminder.dart';

part 'widgets/game_reminder_tile.dart';

part 'tabs/reminders_tab.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          title: const Text('Reminders'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Reminders'),
              Tab(text: 'Scheduled Notifications'),
            ],
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: const TabBarView(
          children: [
            RemindersTab(),
            NotificationsTab(),
          ],
        ),
      ),
    );
  }
}
