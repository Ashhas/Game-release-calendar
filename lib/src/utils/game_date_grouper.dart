import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';

/// Holds filter functions to be used throughout the app
class GameDateGrouper {
  static DateTime tbdDate = DateTime(9999, 1, 1);

  static Map<DateTime, List<Game>> groupGamesByReleaseDate(List<Game> games) {
    Map<DateTime, List<Game>> groupedGames = {};

    for (final game in games) {
      final DateTime dateWithoutTime;

      if (game.firstReleaseDate != null) {
        final releaseDate = DateTime.fromMillisecondsSinceEpoch(
          game.firstReleaseDate! * 1000,
        );

        dateWithoutTime = DateTime(
          releaseDate.year,
          releaseDate.month,
          releaseDate.day,
        );
      } else {
        // Use tbdDate for games without release dates instead of filtering them out
        dateWithoutTime = tbdDate;
      }

      // If the date is not in the map, add new entry for it
      if (!groupedGames.containsKey(dateWithoutTime)) {
        groupedGames[dateWithoutTime] = [];
      }

      // Add the game to the list of games for that day
      groupedGames[dateWithoutTime]?.add(game);
    }

    return groupedGames;
  }

  static Map<DateTime, List<GameReminder>> groupRemindersByReleaseDate(
    List<GameReminder> reminders,
  ) {
    final Map<DateTime, List<GameReminder>> groupedGames = {};

    for (final reminder in reminders) {
      final timestamp = reminder.releaseDate.date;
      final DateTime dateOnly;

      if (timestamp != null) {
        final normalizedDate = DateTime.fromMillisecondsSinceEpoch(
          timestamp * 1000,
        );
        dateOnly = DateTime(
          normalizedDate.year,
          normalizedDate.month,
          normalizedDate.day,
        );
      } else {
        dateOnly = tbdDate;
      }

      groupedGames.putIfAbsent(dateOnly, () => []).add(reminder);
    }

    return groupedGames;
  }
}
