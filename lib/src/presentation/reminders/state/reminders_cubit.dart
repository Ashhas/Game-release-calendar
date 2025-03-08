import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification_payload.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required NotificationClient notificationClient,
  })  : _notificationClient = notificationClient,
        super(RemindersState());

  final NotificationClient _notificationClient;

  void scheduleNotification(Game game) {
    _notificationClient.scheduleNotification(game);
  }

  Future<void> retrievePendingNotifications() async {
    emit(
      state.copyWith(reminders: AsyncValue.loading()),
    );

    final pendingNotifications =
        await _notificationClient.retrievePendingNotifications();

    // Sort based on ScheduledNotification's scheduledDateTime but keep the original PendingNotificationRequest objects
    final sortedNotifications = pendingNotifications.sortedBy(
      (notification) {
        final scheduledNotification =
            _parseScheduledNotificationPayload(notification);
        return scheduledNotification.scheduledDateTime;
      },
    );

    emit(
      state.copyWith(
        reminders: AsyncValue.data(sortedNotifications),
      ),
    );
  }

  void cancelNotification(int gameId) {
    final reminders = state.reminders.asData?.valueOrNull;

    final notificationToCancel = reminders?.firstOrNullWhere(
      (notification) =>
          _parseScheduledNotificationPayload(notification).gameId == gameId,
    );

    if (notificationToCancel != null) {
      _notificationClient.cancelNotification(notificationToCancel.id);
    }
  }

  bool isGameScheduled(int gameId) {
    final reminders = state.reminders.asData?.valueOrNull;
    return reminders?.any(
          (notification) =>
              _parseScheduledNotificationPayload(notification).gameId == gameId,
        ) ??
        false;
  }

  ScheduledNotificationPayload _parseScheduledNotificationPayload(
      PendingNotificationRequest notification) {
    return ScheduledNotificationPayload.fromJson(
        jsonDecode(notification.payload!));
  }
}
