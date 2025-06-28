import 'package:intl/intl.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/constants.dart';

/// Unified utility class for all date/time conversion and formatting operations
class DateUtilities {
  // DateTime Conversion Functions

  /// Converts an epoch in seconds to a DateTime at 10:00 AM local time.
  /// Returns null if the resulting date is in the past.
  static DateTime? computeNotificationDate(int epochSeconds) {
    final rawDate = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    final notificationDate = DateTime(
      rawDate.year,
      rawDate.month,
      rawDate.day,
      Constants.defaultNotificationHour,
      Constants.defaultNotificationMinute,
    );

    return notificationDate.isAfter(DateTime.now()) ? notificationDate : null;
  }

  static DateTime secondSinceEpochToDateTime(int value) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
  }

  // Release Date Formatting Functions

  /// Formats a ReleaseDate object based on its category precision
  /// (from release_category_label_converter.dart)
  static String formatReleaseDate(ReleaseDate releaseDate) {
    if (releaseDate.date == null) {
      return 'TBD';
    }

    final convertedDate = secondSinceEpochToDateTime(releaseDate.date!);

    switch (releaseDate.category) {
      case ReleaseDateCategory.exactDate:
        return DateFormat('dd-MM-yyyy').format(convertedDate);
      case ReleaseDateCategory.yearMonth:
        return DateFormat('MMM yyyy').format(convertedDate);
      case ReleaseDateCategory.quarter:
        return _formatQuarter(convertedDate);
      case ReleaseDateCategory.year:
        return DateFormat('yyyy').format(convertedDate);
      case ReleaseDateCategory.tbd:
        return 'TBD';
      case null:
        return 'TBD';
    }
  }

  /// Formats a Game's release date using the most specific category available
  /// (from release_date_formatter.dart)
  static String formatGameReleaseDate(Game game) {
    final timestamp = game.firstReleaseDate;
    if (timestamp == null) {
      return 'TBD';
    }

    final releaseCategory = _getMostSpecificReleaseCategory(game);

    if (releaseCategory == ReleaseDateCategory.tbd) {
      return 'TBD';
    }

    final dateTime = secondSinceEpochToDateTime(timestamp);

    switch (releaseCategory) {
      case ReleaseDateCategory.exactDate:
        return DateFormat('dd-MM-yyyy').format(dateTime);
      case ReleaseDateCategory.yearMonth:
        return DateFormat('MMM yyyy').format(dateTime);
      case ReleaseDateCategory.quarter:
        return _formatQuarter(dateTime);
      case ReleaseDateCategory.year:
        return DateFormat('yyyy').format(dateTime);
      case ReleaseDateCategory.tbd:
        return 'TBD';
    }
  }

  // Helper Functions

  /// Public method to get the most specific release category for a game
  /// Used for sorting games by category precision
  static ReleaseDateCategory getMostSpecificReleaseCategory(Game game) {
    return _getMostSpecificReleaseCategory(game);
  }

  static ReleaseDateCategory _getMostSpecificReleaseCategory(Game game) {
    if (game.releaseDates == null || game.releaseDates!.isEmpty) {
      return ReleaseDateCategory.tbd;
    }

    // Find the most specific category (lowest value = most specific)
    ReleaseDateCategory mostSpecific = ReleaseDateCategory.tbd;
    for (final releaseDate in game.releaseDates!) {
      // Use dateFormat to determine category if available and more reliable
      ReleaseDateCategory effectiveCategory = _getCategoryFromDateFormat(releaseDate) 
          ?? releaseDate.category 
          ?? ReleaseDateCategory.tbd;
      
      if (effectiveCategory.value < mostSpecific.value) {
        mostSpecific = effectiveCategory;
      }
    }

    return mostSpecific;
  }

  /// Maps IGDB date_format to ReleaseDateCategory
  /// Also handles cases where category field is incorrect but we have better information
  static ReleaseDateCategory? _getCategoryFromDateFormat(ReleaseDate releaseDate) {
    // If we have a human-readable format, try to infer from that first
    if (releaseDate.human != null) {
      final humanLower = releaseDate.human!.toLowerCase();
      if (humanLower.contains('q1') || humanLower.contains('q2') || 
          humanLower.contains('q3') || humanLower.contains('q4')) {
        return ReleaseDateCategory.quarter;
      }
    }
    
    // Use dateFormat if available
    if (releaseDate.dateFormat != null) {
      switch (releaseDate.dateFormat!) {
        case 0: // YYYYMMDDHHMMSS
          return ReleaseDateCategory.exactDate;
        case 1: // YYYYMM  
          return ReleaseDateCategory.yearMonth;
        case 2: // YYYY
          return ReleaseDateCategory.year;
        case 3: // Quarter
        case 4: // Based on the provided data, 4 seems to be quarter too
          return ReleaseDateCategory.quarter;
        default:
          return null;
      }
    }
    
    return null;
  }

  static String _formatQuarter(DateTime dateTime) {
    final quarter = ((dateTime.month - 1) ~/ 3) + 1;
    return 'Q$quarter ${dateTime.year}';
  }
}
