import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/domain/models/game.dart';

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
  Future<void> scheduleNotification(Game game) async {
    final (notificationDate, releaseDateCategory) =
        computeNotificationDate(game);

    if (notificationDate == null) {
      // No upcoming release date found
      return;
    }

    if (releaseDateCategory == null) {
      // No date registered for the game
      return;
    }

    // Convert the notification date to the appropriate timezone
    final tz.TZDateTime notificationTime = tz.TZDateTime.from(
      notificationDate,
      tz.local,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      game.id,
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
        ScheduledNotification.fromGame(
          game: game,
          scheduledReleaseDate: notificationTime,
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
  (DateTime?, ReleaseDateCategory?) computeNotificationDate(Game game) {
    final now = DateTime.now();
    DateTime? earliestDate;
    ReleaseDateCategory? releaseCategory;

    for (ReleaseDate releaseDate in game.releaseDates ?? []) {
      DateTime? releaseDateTime;

      switch (releaseDate.category) {
        case ReleaseDateCategory.exactDate:
          if (releaseDate.date != null) {
            // The date is in Unix timestamp (seconds since epoch)
            releaseDateTime = DateTime.fromMillisecondsSinceEpoch(
              releaseDate.date! * 1000,
            ).toLocal();
            // Set time to 10:00 AM
            releaseDateTime = DateTime(
              releaseDateTime.year,
              releaseDateTime.month,
              releaseDateTime.day,
              10,
              0,
              0,
            );
          }
          break;

        case ReleaseDateCategory.yearMonth:
          if (releaseDate.year != null && releaseDate.month != null) {
            // Last day of the month
            var lastDayOfMonth = DateTime(
              releaseDate.year!,
              releaseDate.month! + 1,
              0,
              10,
              0,
              0,
            );
            releaseDateTime = lastDayOfMonth;
          }
          break;

        case ReleaseDateCategory.quarter:
          if (releaseDate.year != null && releaseDate.quarter != null) {
            // Map quarter to ending month
            int endMonth = releaseDate.quarter! * 3;
            // Last day of the quarter
            var lastDayOfQuarter = DateTime(
              releaseDate.year!,
              endMonth + 1,
              0,
              10,
              0,
              0,
            );
            releaseDateTime = lastDayOfQuarter;
          }
          break;

        case ReleaseDateCategory.year:
          if (releaseDate.year != null) {
            // December 31st of that year at 10:00 AM
            releaseDateTime = DateTime(
              releaseDate.year!,
              12,
              31,
              10,
              0,
              0,
            );
          }
          break;

        case ReleaseDateCategory.tbd:
          // Schedule for December 31st of the current year at 10:00 AM
          releaseDateTime = DateTime(
            now.year,
            12,
            31,
            10,
            0,
            0,
          );
          break;
        case null:
        // TODO: Handle this case.
      }

      // Check if the release date is after the current time
      if (releaseDateTime != null && releaseDateTime.isAfter(now)) {
        if (earliestDate == null || releaseDateTime.isBefore(earliestDate)) {
          earliestDate = releaseDateTime;
          releaseCategory = releaseDate.category;
        }
      }
    }

    return (earliestDate, releaseCategory);
  }
}
