import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
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

  Future<void> scheduleNotification({
    required Game game,
    required ReleaseDate releaseDate,
  }) async {
    await _notificationClient.scheduleNotification(
      game: game,
      releaseDate: releaseDate,
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
        return scheduledNotification.scheduledDateTime;
      },
    );

    emit(
      state.copyWith(
        reminders: AsyncValue.data(sortedNotifications),
      ),
    );
  }

  Future<void> cancelNotification(int gameId) async {
    // Fetch all notifications from the state
    final reminders = state.reminders.asData?.valueOrNull;

    // Emit loading state
    emit(state.copyWith(reminders: AsyncValue.loading()));

    if (reminders != null && reminders.isNotEmpty) {
      // Find the notification to cancel
      final notificationToCancel = reminders.firstOrNullWhere(
        (notification) =>
            _parseScheduledNotificationPayload(notification).gameId == gameId,
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

  Future<void> cancelNotificationForPlatform({
    required int gameId,
    required ReleaseDate releaseDate,
  }) async {
    final reminders = state.reminders.asData?.valueOrNull;

    emit(state.copyWith(reminders: AsyncValue.loading()));

    if (reminders != null && reminders.isNotEmpty) {
      final notificationToCancel = reminders.firstOrNullWhere(
        (notification) =>
            _parseScheduledNotificationPayload(notification).gameId == gameId &&
            _parseScheduledNotificationPayload(notification).releaseDate.id ==
                releaseDate.id,
      );

      if (notificationToCancel != null) {
        final updatedReminders = reminders
            .where((notification) => notification != notificationToCancel)
            .toList();

        await _notificationClient.cancelNotification(notificationToCancel.id);

        emit(state.copyWith(reminders: AsyncValue.data(updatedReminders)));
        return;
      }
    }

    emit(state.copyWith(reminders: AsyncValue.data(reminders ?? [])));
  }

  bool hasScheduledNotifications(int gameId) {
    final reminders = state.reminders.asData?.valueOrNull;
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
    final reminders = state.reminders.asData?.valueOrNull;
    return reminders?.any(
          (notification) =>
              _parseScheduledNotificationPayload(notification).gameId ==
                  gameId &&
              _parseScheduledNotificationPayload(notification).releaseDate.id ==
                  releaseDate.id,
        ) ??
        false;
  }

  ScheduledNotificationPayload _parseScheduledNotificationPayload(
      PendingNotificationRequest notification) {
    return ScheduledNotificationPayload.fromJson(
        jsonDecode(notification.payload!));
  }
}
