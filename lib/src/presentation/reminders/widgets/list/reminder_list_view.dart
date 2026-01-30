import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dartx/dartx.dart';
import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/utils/date_range_utility.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/game_date_grouper.dart';

part 'section/day_section.dart';

part 'game_tile/game_tile.dart';

class RemindersListView extends StatefulWidget {
  const RemindersListView({required this.reminders, super.key});

  final Map<DateTime, List<GameReminder>> reminders;

  @override
  State<RemindersListView> createState() => _RemindersListViewState();
}

class _RemindersListViewState extends State<RemindersListView> {
  @override
  Widget build(BuildContext context) {
    final entries = widget.reminders.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));

    return CustomScrollView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      slivers: [
        if (entries.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No reminders found')),
          )
        else
          for (var entry in entries)
            DaySection(groupedReminders: entry, key: ValueKey(entry.key)),
      ],
    );
  }
}
