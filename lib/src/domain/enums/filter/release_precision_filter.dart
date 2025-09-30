import 'package:hive/hive.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';

part 'release_precision_filter.g.dart';

@HiveType(typeId: 15)
enum ReleasePrecisionFilter {
  @HiveField(0)
  all(0, 'All Release Types'),

  @HiveField(1)
  exactDate(1, 'Exact Dates Only'),

  @HiveField(2)
  yearMonth(2, 'Year & Month'),

  @HiveField(3)
  quarter(3, 'Quarters (Q1, Q2, etc.)'),

  @HiveField(4)
  yearOnly(4, 'Year Only'),

  @HiveField(5)
  tbd(5, 'To Be Determined');

  final int value;
  final String displayText;

  const ReleasePrecisionFilter(this.value, this.displayText);

  static ReleasePrecisionFilter fromValue(int value) {
    return ReleasePrecisionFilter.values.firstWhere(
      (filter) => filter.value == value,
      orElse: () => ReleasePrecisionFilter.all,
    );
  }

  /// Check if a release date matches this filter using proper category resolution
  bool matches(ReleaseDate releaseDate) {
    final resolvedCategory = _resolveActualCategory(releaseDate);

    switch (this) {
      case ReleasePrecisionFilter.all:
        return true;
      case ReleasePrecisionFilter.exactDate:
        return resolvedCategory == ReleaseDateCategory.exactDate;
      case ReleasePrecisionFilter.yearMonth:
        return resolvedCategory == ReleaseDateCategory.yearMonth;
      case ReleasePrecisionFilter.quarter:
        return resolvedCategory == ReleaseDateCategory.quarter;
      case ReleasePrecisionFilter.yearOnly:
        return resolvedCategory == ReleaseDateCategory.year;
      case ReleasePrecisionFilter.tbd:
        return resolvedCategory == ReleaseDateCategory.tbd;
    }
  }

  /// Resolves the actual category using the same logic as DateUtilities
  /// Priority: human text -> dateFormat -> category -> TBD fallback
  ReleaseDateCategory _resolveActualCategory(ReleaseDate releaseDate) {
    // 1. First priority: Parse human-readable text
    if (releaseDate.human != null) {
      final humanLower = releaseDate.human!.toLowerCase();
      // Match various quarter patterns: "q1", "q2", "q1 2025", "q4 2025", "quarter 1", etc.
      if (RegExp(r'\bq[1-4]\b|\bquarter\s*[1-4]\b').hasMatch(humanLower)) {
        return ReleaseDateCategory.quarter;
      }
    }

    // 2. Second priority: Use dateFormat field
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
          // Unknown dateFormat, fall through to category
          break;
      }
    }

    // 3. Third priority: Use category field (often null in IGDB)
    if (releaseDate.category != null) {
      return releaseDate.category!;
    }

    // 4. Final fallback: TBD
    return ReleaseDateCategory.tbd;
  }

  @override
  String toString() {
    return '''ReleasePrecisionFilter(
      value: $value,
      displayText: $displayText
    )''';
  }
}