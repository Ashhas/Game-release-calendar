import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_updates_badge_cubit/game_updates_badge_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_updates_badge_cubit/game_updates_badge_state.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/alert_badge.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/game_updates/game_updates_container.dart';
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
    // Check badge status when reminders screen loads
    context.read<GameUpdatesBadgeCubit>().checkBadgeStatus();
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
          BlocBuilder<GameUpdatesBadgeCubit, GameUpdatesBadgeState>(
            builder: (context, badgeState) {
              return IconButton(
                onPressed: () {
                  // Mark as read when navigating to Game Updates
                  context.read<GameUpdatesBadgeCubit>().markAsReadToday();
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const GameUpdatesContainer()),
                  );
                },
                icon: AlertBadge(
                  showBadge: badgeState.shouldShowBadge,
                  child: Icon(Icons.textsms_outlined),
                ),
              );
            },
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
          final remindersList = state.reminders;

          if (remindersList.isEmpty) {
            return const Center(
              child: Text('No reminders set'),
            );
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(
                    left: context.spacings.m,
                    right: context.spacings.m,
                    top: context.spacings.s,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ViewToggleTab(
                        selectedIndex: state.reminderViewIndex,
                      ),
                      SizedBox(height: context.spacings.xs),
                    ],
                  ),
                ),
              ),
              if (state.reminderViewIndex == 0)
                TwoColumnGridView(reminders: remindersList),
              if (state.reminderViewIndex == 1)
                ThreeColumnGridView(reminders: remindersList),
              if (state.reminderViewIndex == 2)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.spacings.m),
                    child: RemindersListView(
                      reminders: GameDateGrouper.groupRemindersByReleaseDate(
                        remindersList,
                      ),
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: SizedBox(height: context.spacings.s),
              ),
            ],
          );
        },
      ),
    );
  }
}
