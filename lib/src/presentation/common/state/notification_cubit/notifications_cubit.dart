import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/notification_service.dart';

import '../../../../domain/models/notifications/game_reminder.dart';
import 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit({
    required NotificationClient notificationClient,
  })  : _notificationClient = notificationClient,
        super(NotificationsState());

  final NotificationClient _notificationClient;

  Future<void> scheduleNotificationFromGame({
    required Game game,
    required ReleaseDate releaseDate,
  }) async {
    await _notificationClient.scheduleNotificationFromGame(
      game: game,
      releaseDate: releaseDate,
    );

    // Retrieve and update state with the latest pending notifications
    retrievePendingNotifications();
  }

  Future<void> scheduleNotificationFromReminder({
    required GameReminder gameReminder,
  }) async {
    await _notificationClient.scheduleNotificationFromReminder(
      gameReminder: gameReminder,
    );

    // Retrieve and update state with the latest pending notifications
    retrievePendingNotifications();
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
        return scheduledNotification.releaseDate.date ?? 0;
      },
    ).thenBy(
      (notification) {
        final scheduledNotification =
            _parseScheduledNotificationPayload(notification);
        return scheduledNotification.gameName;
      },
    );

    emit(
      state.copyWith(
        reminders: AsyncValue.data(sortedNotifications),
      ),
    );
  }

  Future<void> cancelNotification(int reminderId) async {
    // Fetch all notifications from the state
    final reminders = state.notifications.asData?.valueOrNull;

    // Emit loading state
    emit(state.copyWith(reminders: AsyncValue.loading()));

    if (reminders != null && reminders.isNotEmpty) {
      // Find the notification to cancel
      final notificationToCancel = reminders.firstOrNullWhere(
        (notification) =>
            _parseScheduledNotificationPayload(notification).id == reminderId,
      );

      if (notificationToCancel != null) {
        // Create a new list without the notification to be deleted
        final updatedReminders = reminders
            .where((notification) => notification != notificationToCancel)
            .toList();

        // Cancel the notification
        await _notificationClient.cancelNotification(notificationToCancel.id);

        // Emit data state with the updated list
        emit(state.copyWith(reminders: AsyncValue.data(updatedReminders)));
        return;
      }
    }

    // If reminders are null or empty, emit the original list
    emit(state.copyWith(reminders: AsyncValue.data(reminders ?? [])));
  }

  bool hasScheduledNotifications(int gameId) {
    final reminders = state.notifications.asData?.valueOrNull;
    return reminders?.any(
          (notification) =>
              _parseScheduledNotificationPayload(notification).gameId == gameId,
        ) ??
        false;
  }

  bool isReleaseDateScheduled({
    required int gameId,
    required ReleaseDate releaseDate,
  }) {
    final reminders = state.notifications.asData?.valueOrNull;
    return reminders?.any(
          (notification) =>
              _parseScheduledNotificationPayload(notification).gameId ==
                  gameId &&
              _parseScheduledNotificationPayload(notification).releaseDate.id ==
                  releaseDate.id,
        ) ??
        false;
  }

  GameReminder _parseScheduledNotificationPayload(
      PendingNotificationRequest notification) {
    return GameReminder.fromJson(jsonDecode(notification.payload!));
  }
}
