import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/enums/release_region.dart';
import 'package:game_release_calendar/src/domain/enums/supported_game_platform.dart';

part 'release_date.g.dart'; // For Hive type adapter

@HiveType(typeId: 3)
class ReleaseDate {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int? date;

  @HiveField(2)
  final String? human;

  @HiveField(3)
  final ReleaseDateCategory? category;

  @HiveField(4)
  final int? year;

  @HiveField(5)
  final int? month;

  @HiveField(6)
  final int? quarter;

  @HiveField(7)
  final SupportedGamePlatform? platform;

  @HiveField(8)
  final ReleaseRegion? region;

  @HiveField(9)
  final int? dateFormat;

  const ReleaseDate({
    required this.id,
    this.date,
    this.human,
    this.category,
    this.year,
    this.month,
    this.quarter,
    this.platform,
    this.region,
    this.dateFormat,
  });

  factory ReleaseDate.fromJson(Map<String, dynamic> json) {
    return ReleaseDate(
      id: json['id'],
      date: json['date'],
      human: json['human'],
      category: json['category'] != null 
          ? ReleaseDateCategory.fromValue(json['category']) 
          : null,
      year: json['y'],
      month: json['m'],
      quarter: json['q'],
      platform: json['platform'] != null 
          ? SupportedGamePlatform.fromValue(json['platform']) 
          : null,
      region: json['region'] != null 
          ? ReleaseRegion.fromValue(json['region']) 
          : null,
      dateFormat: json['date_format'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'human': human,
      'category': category?.toValue(),
      'y': year,
      'm': month,
      'q': quarter,
      'platform': platform?.toValue(),
      'region': region?.toValue(),
      'date_format': dateFormat,
    };
  }

  /// Returns true only if this release date has an exact, specific date (not vague like quarter/year)
  bool get hasExactDate {
    // Use the same robust logic as ReleasePrecisionFilter
    return _resolveActualCategory() == ReleaseDateCategory.exactDate && date != null;
  }

  /// Resolves the actual category using robust logic
  /// Priority: human text -> dateFormat -> category -> TBD fallback
  ReleaseDateCategory _resolveActualCategory() {
    // 1. First priority: Parse human-readable text
    if (human != null) {
      final humanLower = human!.toLowerCase();
      // Match various quarter patterns: "q1", "q2", "q1 2025", "q4 2025", "quarter 1", etc.
      if (RegExp(r'\bq[1-4]\b|\bquarter\s*[1-4]\b').hasMatch(humanLower)) {
        return ReleaseDateCategory.quarter;
      }
    }

    // 2. Second priority: Use dateFormat field
    if (dateFormat != null) {
      switch (dateFormat!) {
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
    if (category != null) {
      return category!;
    }

    // 4. Final fallback: TBD
    return ReleaseDateCategory.tbd;
  }

  /// Returns true if this release date is in the past (and has exact date)
  bool get isReleasedWithExactDate {
    if (!hasExactDate) return false;

    final releaseDateTime = DateTime.fromMillisecondsSinceEpoch(date! * 1000);
    return releaseDateTime.isBefore(DateTime.now());
  }

  @override
  String toString() {
    return '''ReleaseDate(
    id: $id,
    date: $date,
    human: $human,
    category: $category,
    year: $year,
    month: $month,
    quarter: $quarter,
    platform: $platform,
    region: $region,
    dateFormat: $dateFormat
  )''';
  }
}
