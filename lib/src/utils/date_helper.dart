class DateHelper {
  /// Returns the start of the current week (Monday).
  static DateTime getStartOfThisWeek() {
    DateTime now = DateTime.now();
    int daysToSubtract = now.weekday - DateTime.monday;
    return DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: daysToSubtract));
  }

  /// Returns the end of the current week (Sunday).
  static DateTime getEndOfThisWeek() {
    DateTime startOfThisWeek = getStartOfThisWeek();
    return startOfThisWeek.add(Duration(days: 6));
  }

  static DateTime getStartOfThisMonth() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  static DateTime getEndOfThisMonth() {
    DateTime now = DateTime.now();
    DateTime startOfNextMonth = (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1); // Handle December to January transition
    return startOfNextMonth.subtract(Duration(days: 1));
  }

  /// Returns the start of the next month.
  static DateTime getStartOfNextMonth() {
    DateTime now = DateTime.now();
    return (now.month < 12)
        ? DateTime(now.year, now.month + 1, 1)
        : DateTime(now.year + 1, 1, 1); // Handle December to January transition
  }

  static DateTime getEndOfNextMonth() {
    DateTime startOfNextMonth = getStartOfNextMonth();
    DateTime startOfFollowingMonth = (startOfNextMonth.month < 12)
        ? DateTime(startOfNextMonth.year, startOfNextMonth.month + 1, 1)
        : DateTime(startOfNextMonth.year + 1, 1, 1);
    return startOfFollowingMonth.subtract(Duration(days: 1));
  }
}
