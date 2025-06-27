class Constants {
  static const int gameRequestLimit = 500;
  static const int defaultNotificationHour = 10;
  static const int defaultNotificationMinute = 00;
  static const String placeholderImageUrl =
      'https://placehold.co/400x600/d4d4d4/FFFFFF/png?text=No+cover&font=roboto';
  static DateTime maxDateLimit = DateTime(9999, 1, 1);

  /// Timestamp value used for TBD (To Be Determined) release dates in sorting
  /// This ensures TBD items appear at the bottom of chronologically sorted lists
  static const int tbdTimestamp = 4102444800; // DateTime(9999, 1, 1) in seconds
}
