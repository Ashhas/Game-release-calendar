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
      print('DEBUG: Notification not scheduled for ${game.name} - date is in the past or null');
      return;
    }

    final tz.TZDateTime notificationTime = tz.TZDateTime.from(
      notificationDate,
      tz.local,
    );

    print('DEBUG: Scheduling notification for ${game.name} at $notificationTime');

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
          importance: Importance.high,
          priority: Priority.high,
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

    print('DEBUG: Notification scheduled successfully for ${game.name}');
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
          importance: Importance.high,
          priority: Priority.high,
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
    print('DEBUG: Cancelled notification for gameId: $gameId');
  }

  /// Debug method to check current pending notifications
  Future<void> debugPendingNotifications() async {
    final pending = await retrievePendingNotifications();
    print('DEBUG: Current pending notifications: ${pending.length}');
    for (final notification in pending) {
      print('  - ID: ${notification.id}, Title: ${notification.title}, Body: ${notification.body}');
    }
  }

  /// Test method to send an immediate notification
  Future<void> sendTestNotification() async {
    await _flutterLocalNotificationsPlugin.show(
      99999,
      'Test Notification',
      'This is a test to verify notifications are working!',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'release_day_channel',
          'Game Release Notifications',
          channelDescription: 'Notifications for game release days',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
    print('DEBUG: Test notification sent');
  }
}
