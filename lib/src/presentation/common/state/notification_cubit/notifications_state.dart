import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';

class NotificationsState {
  AsyncValue<List<PendingNotificationRequest>> notifications;

  NotificationsState({
    this.notifications = const AsyncValue.data([]),
  });

  NotificationsState copyWith({
    AsyncValue<List<PendingNotificationRequest>>? reminders,
  }) {
    return NotificationsState(
      notifications: reminders ?? this.notifications,
    );
  }
}
