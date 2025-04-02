import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';

class RemindersState {
  final List<GameReminder> reminders;

  const RemindersState({
    this.reminders = const [],
  });

  RemindersState copyWith({
    List<GameReminder>? reminders,
  }) {
    return RemindersState(
      reminders: reminders ?? this.reminders,
    );
  }
}
