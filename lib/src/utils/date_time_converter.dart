class DateTimeConverter {
  static DateTime secondSinceEpochToDateTime(int value) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(value * 1000);
    return DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
  }
}
