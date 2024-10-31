import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';

class RemindersState {
  AsyncValue<List<PendingNotificationRequest>> reminders;

  RemindersState({
    this.reminders = const AsyncValue.data([]),
  });

  RemindersState copyWith({
    AsyncValue<List<PendingNotificationRequest>>? reminders,
  }) {
    return RemindersState(
      reminders: reminders ?? this.reminders,
    );
  }
}
