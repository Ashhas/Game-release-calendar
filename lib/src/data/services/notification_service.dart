import 'dart:convert';

import 'package:dartx/dartx.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/scheduled_notification.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';

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
    final (notificationDate, releaseCategory) = computeNotificationDate(game);

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
  (DateTime?, ReleaseDateCategory?) computeNotificationDate(Game game) {
    List<ReleaseDate>? sortedReleaseDates;
    DateTime? earliestReleaseDate;
    ReleaseDateCategory? earliestReleaseCategory;

    sortedReleaseDates = game.releaseDates?.sortedBy(
          (releaseDate) => releaseDate.date!,
        ) ??
        null;

    if (sortedReleaseDates?.first.date != null) {
      earliestReleaseDate = DateTime.fromMillisecondsSinceEpoch(
        sortedReleaseDates!.first.date! * 1000,
      );

      if (earliestReleaseDate.isAfter(DateTime.now())) {
        earliestReleaseCategory = sortedReleaseDates.first.category;
        earliestReleaseDate = DateTime(
          earliestReleaseDate.year,
          earliestReleaseDate.month,
          earliestReleaseDate.day,
          10,
          0,
          0,
        );
      }
    }

    return (earliestReleaseDate, earliestReleaseCategory);
  }
}
