import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/date_time_converter.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification_payload.dart';

class NotificationClient {
  NotificationClient() {
    _flutterLocalNotificationsPlugin =
        GetIt.instance.get<FlutterLocalNotificationsPlugin>();
  }

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<List<PendingNotificationRequest>>
      retrievePendingNotifications() async =>
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

  /// Schedules a notification for the game's upcoming release date.
  Future<void> scheduleNotification({
    required Game game,
    required ReleaseDate releaseDate,
  }) async {
    final (notificationDate, releaseCategory) = computeNotificationDate(
      game: game,
      releaseDate: releaseDate,
    );

    if (notificationDate == null) {
      // No upcoming release date found
      return;
    }

    // Convert the notification date to the appropriate timezone
    final tz.TZDateTime notificationTime = tz.TZDateTime.from(
      notificationDate,
      tz.local,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      releaseDate.id!,
      'Release Day: ${game.name}',
      '${game.name} will be available today! Get ready to play.',
      notificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'release_day_channel',
          'Game Release Notifications',
          channelDescription: 'Notifications for game release days',
        ),
      ),
      payload: jsonEncode(
        ScheduledNotificationPayload.fromGame(
          game: game,
          scheduledReleaseDate: notificationTime,
          releaseDate: releaseDate,
          releaseDateCategory: releaseCategory ?? ReleaseDateCategory.exactDate,
        ).toJson(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int gameId) async {
    await _flutterLocalNotificationsPlugin.cancel(gameId);
  }

  /// Computes the notification date based on the game's release dates.
  /// For now, we'll by default take the earliest release date and set the
  /// notification time to 10:00 AM.
  (DateTime?, ReleaseDateCategory?) computeNotificationDate({
    required Game game,
    required ReleaseDate releaseDate,
  }) {
    DateTime? convertedDate;
    ReleaseDateCategory? convertedCategory;

    if (releaseDate.date != null) {
      convertedDate = DateTimeConverter.secondSinceEpochToDateTime(
        releaseDate.date!,
      );

      if (convertedDate.isAfter(DateTime.now())) {
        convertedCategory = releaseDate.category;

        // Set the notification time to 10:00 AM
        convertedDate = DateTime(
          convertedDate.year,
          convertedDate.month,
          convertedDate.day,
          10,
        );
      }
    }

    return (convertedDate, convertedCategory);
  }
}
