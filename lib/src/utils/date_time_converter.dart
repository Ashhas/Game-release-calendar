class DateTimeConverter {
  /// Converts an epoch in seconds to a DateTime at 10:00 AM local time.
  /// Returns null if the resulting date is in the past.
  static DateTime? computeNotificationDate(int epochSeconds) {
    final rawDate = DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000);
    final notificationDate = DateTime(
      rawDate.year,
      rawDate.month,
      rawDate.day,
      10, // 10:00 AM
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
}
