import 'package:hive_ce/hive.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/enums/release_region.dart';
import 'package:game_release_calendar/src/domain/enums/supported_game_platform.dart';

part 'release_date.g.dart';

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

  bool get hasExactDate {
    return _resolveActualCategory() == ReleaseDateCategory.exactDate && date != null;
  }

  ReleaseDateCategory _resolveActualCategory() {
    if (human != null) {
      final humanLower = human!.toLowerCase();
      if (RegExp(r'\bq[1-4]\b|\bquarter\s*[1-4]\b').hasMatch(humanLower)) {
        return ReleaseDateCategory.quarter;
      }
    }

    if (dateFormat != null) {
      switch (dateFormat!) {
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

    if (category != null) {
      return category!;
    }

    return ReleaseDateCategory.tbd;
  }

  bool get isReleasedWithExactDate {
    if (!hasExactDate) return false;
    final releaseDateTime = DateTime.fromMillisecondsSinceEpoch(date! * 1000);
    return releaseDateTime.isBefore(DateTime.now());
  }

  @override
  String toString() {
    return 'ReleaseDate(id: $id, date: $date, human: $human, category: $category, year: $year, month: $month, quarter: $quarter, platform: $platform, region: $region, dateFormat: $dateFormat)';
  }
}
