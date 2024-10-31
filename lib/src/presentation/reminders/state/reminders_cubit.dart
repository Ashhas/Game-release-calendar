import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required NotificationClient notificationClient,
  })  : _notificationClient = notificationClient,
        super(RemindersState());

  final NotificationClient _notificationClient;

  Future<void> retrievePendingNotifications() async {
    final pendingNotifications =
        await _notificationClient.retrievePendingNotifications();

    final sortedNotification = pendingNotifications.sortedBy(
      (PendingNotificationRequest notification) {
        final scheduledNotification = ScheduledNotification.fromJson(
          jsonDecode(notification.payload!),
        );

        return scheduledNotification.scheduledDateTime;
      },
    );

    emit(
      state.copyWith(
        reminders: AsyncValue.data(sortedNotification),
      ),
    );
  }
}
