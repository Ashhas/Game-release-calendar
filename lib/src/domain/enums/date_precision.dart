/// Represents the precision level of a release date for grouping purposes.
/// Used to separate exact dates from TBD periods in the game list.
enum DatePrecision {
  /// Exact day known (e.g., "February 15, 2025")
  exactDay,

  /// Only month known (e.g., "February 2025")
  month,

  /// Only quarter known (e.g., "Q1 2025")
  quarter,

  /// Only year known (e.g., "2025")
  year,

  /// No release date information
  tbd;

  /// Whether this precision represents a TBD/imprecise date
  bool get isTbd => this != exactDay;

  /// Get sort order - exact dates first, then by specificity
  int get sortOrder {
    switch (this) {
      case DatePrecision.exactDay:
        return 0;
      case DatePrecision.month:
        return 1;
      case DatePrecision.quarter:
        return 2;
      case DatePrecision.year:
        return 3;
      case DatePrecision.tbd:
        return 4;
    }
  }
}
