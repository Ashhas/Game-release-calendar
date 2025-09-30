import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';

/// Holds filter functions to be used throughout the app
class GameDateGrouper {
  static DateTime get tbdDate => Constants.maxDateLimit;

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

    // Sort games within each day using the same logic that determines game tile labels
    for (final entry in groupedGames.entries) {
      entry.value.sort((a, b) {
        // Use the exact same logic as game tiles: get formatted release dates
        final formattedA = DateUtilities.formatGameReleaseDate(a);
        final formattedB = DateUtilities.formatGameReleaseDate(b);
        
        // Get categories for comparison (most specific first)
        final categoryA = DateUtilities.getMostSpecificReleaseCategory(a);
        final categoryB = DateUtilities.getMostSpecificReleaseCategory(b);
        
        // Primary sort: by category precision (lower value = more specific = comes first)
        final categoryComparison = categoryA.value.compareTo(categoryB.value);
        if (categoryComparison != 0) {
          return categoryComparison;
        }
        
        // Secondary sort: within same category, sort by the actual formatted string
        // This ensures consistent ordering with what users see in the UI
        final formatComparison = formattedA.compareTo(formattedB);
        if (formatComparison != 0) {
          return formatComparison;
        }
        
        // Tertiary sort: if everything else is identical, sort by game name
        return a.name.compareTo(b.name);
      });
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

    // Sort reminders within each day: exact dates first, then by game name
    for (final entry in groupedGames.entries) {
      entry.value.sort((a, b) {
        // Primary sort: exact dates come before vague dates
        final aIsExact = a.releaseDate.hasExactDate;
        final bIsExact = b.releaseDate.hasExactDate;

        if (aIsExact && !bIsExact) return -1; // a comes first
        if (!aIsExact && bIsExact) return 1;  // b comes first

        // Secondary sort: by game name if both have same precision
        return a.gameName.compareTo(b.gameName);
      });
    }

    return groupedGames;
  }
}
