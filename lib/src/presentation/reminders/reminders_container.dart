import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:intl/intl.dart';
import 'package:moon_design/moon_design.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_state.dart';
import 'package:game_release_calendar/src/presentation/game_detail/game_detail_view.dart';
import 'package:game_release_calendar/src/presentation/more/more_container.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_card.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/list/reminder_list_view.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';
import '../../domain/models/notifications/game_reminder.dart';

part 'widgets/game_reminder_tile.dart';

part 'tabs/reminders_tab.dart';

part 'tabs/notifications_tab.dart';

class RemindersContainer extends StatefulWidget {
  const RemindersContainer({super.key});

  @override
  State<RemindersContainer> createState() => _RemindersContainerState();
}

class _RemindersContainerState extends State<RemindersContainer>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    context.read<RemindersCubit>().loadGames();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: const Text('Reminders'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(context.spacings.xxxl),
          child: Padding(
            padding: EdgeInsets.only(bottom: context.spacings.xs),
            child: MoonTabBar.pill(
              tabController: _tabController,
              pillTabs: [
                MoonPillTab(
                  label: Text('Reminders'),
                ),
                MoonPillTab(
                  label: Text('Notifications'),
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: TabBarView(
        controller: _tabController,
        children: [
          RemindersTab(),
          NotificationsTab(),
        ],
      ),
    );
  }
}
