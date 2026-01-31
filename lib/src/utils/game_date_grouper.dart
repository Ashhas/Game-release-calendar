import 'package:game_release_calendar/src/domain/enums/date_precision.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/game_section.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';

/// Holds filter functions to be used throughout the app
class GameDateGrouper {
  static DateTime get tbdDate => Constants.maxDateLimit;

  /// Groups games into sections by date AND precision level.
  /// TBD sections (month/quarter/year) appear before their day-specific counterparts.
  static List<GameSection> groupGamesIntoSections(List<Game> games) {
    final Map<String, GameSection> sectionMap = {};

    for (final game in games) {
      final precision = _getGamePrecision(game);
      final sectionDate = _getSectionDate(game, precision);
      final key = '${sectionDate.millisecondsSinceEpoch}_${precision.name}';

      if (sectionMap.containsKey(key)) {
        sectionMap[key]!.games.add(game);
      } else {
        sectionMap[key] = GameSection(
          date: sectionDate,
          precision: precision,
          games: [game],
        );
      }
    }

    // Sort sections: by date first, then exact dates before TBD sections
    final sections = sectionMap.values.toList()
      ..sort((a, b) {
        // First compare by date
        final dateComparison = a.date.compareTo(b.date);
        if (dateComparison != 0) return dateComparison;

        // Same date: exact dates come first, then TBD sections below
        return a.precision.sortOrder.compareTo(b.precision.sortOrder);
      });

    // Sort games within each section by name
    for (final section in sections) {
      section.games.sort((a, b) => a.name.compareTo(b.name));
    }

    return sections;
  }

  /// Determines the precision level for a game based on its release date info.
  static DatePrecision _getGamePrecision(Game game) {
    if (game.firstReleaseDate == null) {
      return DatePrecision.tbd;
    }

    final category = DateUtilities.getMostSpecificReleaseCategory(game);

    switch (category) {
      case ReleaseDateCategory.exactDate:
        return DatePrecision.exactDay;
      case ReleaseDateCategory.yearMonth:
        return DatePrecision.month;
      case ReleaseDateCategory.quarter:
        return DatePrecision.quarter;
      case ReleaseDateCategory.year:
        return DatePrecision.year;
      case ReleaseDateCategory.tbd:
        return DatePrecision.tbd;
    }
  }

  /// Gets the section date for a game based on its precision.
  /// For TBD periods, normalizes to the start of that period.
  static DateTime _getSectionDate(Game game, DatePrecision precision) {
    if (game.firstReleaseDate == null) {
      return tbdDate;
    }

    final releaseDate = DateTime.fromMillisecondsSinceEpoch(
      game.firstReleaseDate! * 1000,
    );

    switch (precision) {
      case DatePrecision.exactDay:
        return DateTime(releaseDate.year, releaseDate.month, releaseDate.day);
      case DatePrecision.month:
        // End of month - TBD sections appear after exact dates for that month
        // Using day 0 of next month gives last day of current month
        return DateTime(releaseDate.year, releaseDate.month + 1, 0);
      case DatePrecision.quarter:
        // End of quarter - TBD sections appear after exact dates for that quarter
        final quarterEndMonth = ((releaseDate.month - 1) ~/ 3) * 3 + 3;
        return DateTime(releaseDate.year, quarterEndMonth + 1, 0);
      case DatePrecision.year:
        // End of year - TBD sections appear after exact dates for that year
        return DateTime(releaseDate.year, 12, 31);
      case DatePrecision.tbd:
        return tbdDate;
    }
  }

  /// Public method to get precision for a game (used by UI for styling)
  static DatePrecision getGamePrecision(Game game) => _getGamePrecision(game);

  @Deprecated('Use groupGamesIntoSections instead for proper TBD handling')
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
        if (!aIsExact && bIsExact) return 1; // b comes first

        // Secondary sort: by game name if both have same precision
        return a.gameName.compareTo(b.gameName);
      });
    }

    return groupedGames;
  }
}
