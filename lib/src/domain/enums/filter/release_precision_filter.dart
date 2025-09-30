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

  ReleaseDateCategory _resolveActualCategory(ReleaseDate releaseDate) {
    if (releaseDate.human != null) {
      final humanLower = releaseDate.human!.toLowerCase();
      if (RegExp(r'\bq[1-4]\b|\bquarter\s*[1-4]\b').hasMatch(humanLower)) {
        return ReleaseDateCategory.quarter;
      }
    }

    if (releaseDate.dateFormat != null) {
      switch (releaseDate.dateFormat!) {
        case 0:
          return ReleaseDateCategory.exactDate;
        case 1:
          return ReleaseDateCategory.yearMonth;
        case 2:
          return ReleaseDateCategory.year;
        case 3:
        case 4:
          return ReleaseDateCategory.quarter;
        default:
          break;
      }
    }

    if (releaseDate.category != null) {
      return releaseDate.category!;
    }

    return ReleaseDateCategory.tbd;
  }

  @override
  String toString() {
    return 'ReleasePrecisionFilter(value: $value, displayText: $displayText)';
  }
}