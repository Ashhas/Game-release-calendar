import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';

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

  /// Returns the start of the next 3 months (current date to 3 months ahead).
  static DateTime getStartOfNext3Months() {
    DateTime now = DateTime.now();
    return DateTime(
        now.year, now.month, 1); // Start from the 1st of the current month
  }

  /// Returns the end of the next 3 months (3 months after the current month).
  static DateTime getEndOfNext3Months() {
    DateTime now = DateTime.now();
    DateTime threeMonthsAhead = (now.month + 3 <= 12)
        ? DateTime(now.year, now.month + 3, 1)
        : DateTime(now.year + 1, (now.month + 3) % 12,
            1); // Handle year transition if needed
    return threeMonthsAhead
        .subtract(Duration(days: 1)); // Last day of the third month
  }

  static DateTimeRange getDateRangeForChoice(DateFilterChoice choice) {
    switch (choice) {
      case DateFilterChoice.thisWeek:
        return DateTimeRange(
          start: DateHelper.getStartOfThisWeek(),
          end: DateHelper.getEndOfThisWeek(),
        );
      case DateFilterChoice.thisMonth:
        return DateTimeRange(
          start: DateHelper.getStartOfThisMonth(),
          end: DateHelper.getEndOfThisMonth(),
        );
      case DateFilterChoice.nextMonth:
        return DateTimeRange(
          start: DateHelper.getStartOfNextMonth(),
          end: DateHelper.getEndOfNextMonth(),
        );
      case DateFilterChoice.next3Months:
        return DateTimeRange(
          start: DateHelper.getStartOfNext3Months(),
          end: DateHelper.getEndOfNext3Months(),
        );
    }
  }
}
