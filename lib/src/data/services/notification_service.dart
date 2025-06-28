import 'dart:convert';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_it/get_it.dart';
import 'package:timezone/timezone.dart' as tz;

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import '../../domain/models/notifications/game_reminder.dart';

class NotificationClient {
  NotificationClient() {
    _flutterLocalNotificationsPlugin =
        GetIt.instance.get<FlutterLocalNotificationsPlugin>();
  }

  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  Future<List<PendingNotificationRequest>>
      retrievePendingNotifications() async =>
          await _flutterLocalNotificationsPlugin.pendingNotificationRequests();

  /// Schedules a notification using the [Game] Object
  Future<void> scheduleNotificationFromGame({
    required Game game,
    required ReleaseDate releaseDate,
  }) async {
    final notificationDate = DateUtilities.computeNotificationDate(
      releaseDate.date ?? 0,
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
      releaseDate.id,
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
        GameReminder.fromGame(
          game: game,
          releaseDate: releaseDate,
          releaseDateCategory:
              releaseDate.category ?? ReleaseDateCategory.exactDate,
          notificationDate: notificationDate,
        ).toJson(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Schedules a notification using the [GameReminder] Object
  Future<void> scheduleNotificationFromReminder({
    required GameReminder gameReminder,
  }) async {
    if (gameReminder.notificationDate == null) {
      // Invalid reminder
      return;
    }

    // Convert the notification date to the appropriate timezone
    final tz.TZDateTime notificationTime = tz.TZDateTime.from(
      gameReminder.notificationDate!,
      tz.local,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      gameReminder.releaseDate.id,
      'Release Day: ${gameReminder.gameName}',
      '${gameReminder.gameName} will be available today! Get ready to play.',
      notificationTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'release_day_channel',
          'Game Release Notifications',
          channelDescription: 'Notifications for game release days',
        ),
      ),
      payload: jsonEncode(gameReminder.toJson()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int gameId) async {
    await _flutterLocalNotificationsPlugin.cancel(gameId);
  }
}
