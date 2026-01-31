import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';

class RemindersState {
  final List<GameReminder> reminders;
  final int reminderViewIndex;

  const RemindersState({this.reminders = const [], this.reminderViewIndex = 0});

  RemindersState copyWith({
    List<GameReminder>? reminders,
    int? reminderViewIndex,
  }) {
    return RemindersState(
      reminders: reminders ?? this.reminders,
      reminderViewIndex: reminderViewIndex ?? this.reminderViewIndex,
    );
  }
}
