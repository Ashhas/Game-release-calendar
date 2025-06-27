import 'package:game_release_calendar/src/utils/constants.dart';

/// Utility class for comparing release dates with proper TBD handling.
///
/// Provides consistent sorting behavior where:
/// - Actual release dates are sorted chronologically
/// - TBD (null) dates always appear at the bottom
class ReleaseDateComparator {
  /// Returns a timestamp value for sorting, with TBD dates mapped to a high value
  /// to ensure they appear at the bottom of sorted lists.
  static int getSortableTimestamp(int? releaseDate) {
    return releaseDate ?? Constants.tbdTimestamp;
  }

  /// Compares two nullable release date timestamps.
  /// TBD (null) dates are considered greater than any actual date.
  static int compare(int? dateA, int? dateB) {
    final timestampA = getSortableTimestamp(dateA);
    final timestampB = getSortableTimestamp(dateB);
    return timestampA.compareTo(timestampB);
  }

  /// Returns true if the given timestamp represents a TBD date.
  static bool isTbd(int? releaseDate) {
    return releaseDate == null;
  }
}
