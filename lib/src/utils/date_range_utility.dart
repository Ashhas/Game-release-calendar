import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/utils/constants.dart';

class DateRangeUtility {
  /// Returns the start of the current day (00:00:00).
  static DateTime getStartOfToday() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

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
      case DateFilterChoice.allTime:
        return DateTimeRange(
          start: DateRangeUtility.getStartOfToday(),
          end: Constants.maxDateLimit,
        );
      case DateFilterChoice.thisWeek:
        return DateTimeRange(
          start: DateRangeUtility.getStartOfThisWeek(),
          end: DateRangeUtility.getEndOfThisWeek(),
        );
      case DateFilterChoice.thisMonth:
        return DateTimeRange(
          start: DateRangeUtility.getStartOfThisMonth(),
          end: DateRangeUtility.getEndOfThisMonth(),
        );
      case DateFilterChoice.nextMonth:
        return DateTimeRange(
          start: DateRangeUtility.getStartOfNextMonth(),
          end: DateRangeUtility.getEndOfNextMonth(),
        );
      case DateFilterChoice.next3Months:
        return DateTimeRange(
          start: DateRangeUtility.getStartOfNext3Months(),
          end: DateRangeUtility.getEndOfNext3Months(),
        );
    }
  }

  static String getDayDifferenceLabel(
    DateTime otherDate, {
    DateTime? currentDate,
  }) {
    final now = currentDate ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final comparisonDate =
        DateTime(otherDate.year, otherDate.month, otherDate.day);

    final differenceInDays = comparisonDate.difference(today).inDays;

    if (differenceInDays == 0) {
      return 'Today';
    } else if (differenceInDays == 1) {
      return 'Tomorrow';
    } else if (differenceInDays <= 30) {
      return '$differenceInDays days';
    } else {
      final differenceInWeeks = (differenceInDays / 7).floor();
      return '$differenceInWeeks week${differenceInWeeks > 1 ? 's' : ''}';
    }
  }
}
