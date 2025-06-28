import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/enums/release_region.dart';
import 'package:game_release_calendar/src/domain/enums/supported_game_platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';

void main() {
  group('ReleaseDate Model', () {
    group('constructor', () {
      test('should create ReleaseDate with required fields only', () {
        final releaseDate = ReleaseDate(id: 1);
        
        expect(releaseDate.id, equals(1));
        expect(releaseDate.date, isNull);
        expect(releaseDate.human, isNull);
        expect(releaseDate.category, isNull);
        expect(releaseDate.year, isNull);
        expect(releaseDate.month, isNull);
        expect(releaseDate.quarter, isNull);
        expect(releaseDate.platform, isNull);
        expect(releaseDate.region, isNull);
        expect(releaseDate.dateFormat, isNull);
      });

      test('should create ReleaseDate with all fields', () {
        final releaseDate = ReleaseDate(
          id: 716132,
          date: 1751241600,
          human: 'Q2 2025',
          category: ReleaseDateCategory.quarter,
          year: 2025,
          month: 6,
          quarter: 2,
          platform: SupportedGamePlatform.windows,
          region: ReleaseRegion.worldwide,
          dateFormat: 4,
        );
        
        expect(releaseDate.id, equals(716132));
        expect(releaseDate.date, equals(1751241600));
        expect(releaseDate.human, equals('Q2 2025'));
        expect(releaseDate.category, equals(ReleaseDateCategory.quarter));
        expect(releaseDate.year, equals(2025));
        expect(releaseDate.month, equals(6));
        expect(releaseDate.quarter, equals(2));
        expect(releaseDate.platform, equals(SupportedGamePlatform.windows));
        expect(releaseDate.region, equals(ReleaseRegion.worldwide));
        expect(releaseDate.dateFormat, equals(4));
      });
    });

    group('fromJson', () {
      test('should parse complete JSON correctly', () {
        final json = {
          'id': 716132,
          'date': 1751241600,
          'human': 'Q2 2025',
          'category': 2, // Quarter category
          'y': 2025,
          'm': 6,
          'q': 2,
          'platform': 6, // Windows platform
          'region': 8, // Worldwide region
          'date_format': 4,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.id, equals(716132));
        expect(releaseDate.date, equals(1751241600));
        expect(releaseDate.human, equals('Q2 2025'));
        expect(releaseDate.category, equals(ReleaseDateCategory.quarter));
        expect(releaseDate.year, equals(2025));
        expect(releaseDate.month, equals(6));
        expect(releaseDate.quarter, equals(2));
        expect(releaseDate.platform, equals(SupportedGamePlatform.windows));
        expect(releaseDate.region, equals(ReleaseRegion.worldwide));
        expect(releaseDate.dateFormat, equals(4));
      });

      test('should parse minimal JSON correctly', () {
        final json = {'id': 1};
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.id, equals(1));
        expect(releaseDate.date, isNull);
        expect(releaseDate.human, isNull);
        expect(releaseDate.category, isNull);
        expect(releaseDate.year, isNull);
        expect(releaseDate.month, isNull);
        expect(releaseDate.quarter, isNull);
        expect(releaseDate.platform, isNull);
        expect(releaseDate.region, isNull);
        expect(releaseDate.dateFormat, isNull);
      });

      test('should handle null category gracefully', () {
        final json = {
          'id': 1,
          'category': null,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.category, isNull);
      });

      test('should handle invalid category values', () {
        final json = {
          'id': 1,
          'category': 999, // Invalid category value
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        // Should fallback to TBD for invalid values
        expect(releaseDate.category, equals(ReleaseDateCategory.tbd));
      });

      test('should handle null platform gracefully', () {
        final json = {
          'id': 1,
          'platform': null,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.platform, isNull);
      });

      test('should handle invalid platform values', () {
        final json = {
          'id': 1,
          'platform': 999, // Invalid platform value
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        // Should handle invalid platform gracefully by returning fallback
        expect(releaseDate.platform, isNotNull);
      });

      test('should handle null region gracefully', () {
        final json = {
          'id': 1,
          'region': null,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.region, isNull);
      });

      test('should handle missing date_format field', () {
        final json = {
          'id': 1,
          'date': 1751241600,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.dateFormat, isNull);
      });

      test('should parse date_format field correctly', () {
        final dateFormatTests = [0, 1, 2, 3, 4, null];
        
        for (final dateFormat in dateFormatTests) {
          final json = {
            'id': 1,
            'date_format': dateFormat,
          };
          
          final releaseDate = ReleaseDate.fromJson(json);
          expect(releaseDate.dateFormat, equals(dateFormat));
        }
      });

      test('should handle user data scenario (category 4 with quarter human)', () {
        // This represents the user's original issue
        final json = {
          'id': 716132,
          'category': 4, // TBD category (incorrect)
          'date': 1751241600,
          'human': 'Q2 2025', // But human shows quarter
          'date_format': 4, // And date_format indicates quarter
          'm': 6,
          'y': 2025,
        };
        
        final releaseDate = ReleaseDate.fromJson(json);
        
        expect(releaseDate.category, equals(ReleaseDateCategory.tbd));
        expect(releaseDate.human, equals('Q2 2025'));
        expect(releaseDate.dateFormat, equals(4));
        expect(releaseDate.date, equals(1751241600));
      });
    });

    group('toJson', () {
      test('should serialize complete ReleaseDate correctly', () {
        final releaseDate = ReleaseDate(
          id: 716132,
          date: 1751241600,
          human: 'Q2 2025',
          category: ReleaseDateCategory.quarter,
          year: 2025,
          month: 6,
          quarter: 2,
          platform: SupportedGamePlatform.windows,
          region: ReleaseRegion.worldwide,
          dateFormat: 4,
        );
        
        final json = releaseDate.toJson();
        
        expect(json['id'], equals(716132));
        expect(json['date'], equals(1751241600));
        expect(json['human'], equals('Q2 2025'));
        expect(json['category'], equals(2)); // Quarter category value
        expect(json['y'], equals(2025));
        expect(json['m'], equals(6));
        expect(json['q'], equals(2));
        expect(json['platform'], equals(6)); // Windows platform value
        expect(json['region'], equals(8)); // Worldwide region value
        expect(json['date_format'], equals(4));
      });

      test('should serialize minimal ReleaseDate correctly', () {
        final releaseDate = ReleaseDate(id: 1);
        
        final json = releaseDate.toJson();
        
        expect(json['id'], equals(1));
        expect(json['date'], isNull);
        expect(json['human'], isNull);
        expect(json['category'], isNull);
        expect(json['y'], isNull);
        expect(json['m'], isNull);
        expect(json['q'], isNull);
        expect(json['platform'], isNull);
        expect(json['region'], isNull);
        expect(json['date_format'], isNull);
      });

      test('should preserve dateFormat field in serialization', () {
        final releaseDate = ReleaseDate(
          id: 1,
          dateFormat: 3,
        );
        
        final json = releaseDate.toJson();
        
        expect(json['date_format'], equals(3));
      });
    });

    group('toString', () {
      test('should include all fields in toString output', () {
        final releaseDate = ReleaseDate(
          id: 716132,
          date: 1751241600,
          human: 'Q2 2025',
          category: ReleaseDateCategory.quarter,
          year: 2025,
          month: 6,
          quarter: 2,
          platform: SupportedGamePlatform.windows,
          region: ReleaseRegion.worldwide,
          dateFormat: 4,
        );
        
        final stringOutput = releaseDate.toString();
        
        expect(stringOutput, contains('id: 716132'));
        expect(stringOutput, contains('date: 1751241600'));
        expect(stringOutput, contains('human: Q2 2025'));
        expect(stringOutput, contains('category: ReleaseDateCategory('));
        expect(stringOutput, contains('year: 2025'));
        expect(stringOutput, contains('month: 6'));
        expect(stringOutput, contains('quarter: 2'));
        expect(stringOutput, contains('platform: SupportedGamePlatform('));
        expect(stringOutput, contains('region: ReleaseRegion.worldwide'));
        expect(stringOutput, contains('dateFormat: 4'));
      });

      test('should handle null values in toString', () {
        final releaseDate = ReleaseDate(id: 1);
        
        final stringOutput = releaseDate.toString();
        
        expect(stringOutput, contains('id: 1'));
        expect(stringOutput, contains('date: null'));
        expect(stringOutput, contains('dateFormat: null'));
      });
    });

    group('JSON round trip', () {
      test('should maintain data integrity through JSON serialization cycle', () {
        final originalReleaseDate = ReleaseDate(
          id: 716132,
          date: 1751241600,
          human: 'Q2 2025',
          category: ReleaseDateCategory.quarter,
          year: 2025,
          month: 6,
          quarter: 2,
          platform: SupportedGamePlatform.windows,
          region: ReleaseRegion.worldwide,
          dateFormat: 4,
        );
        
        // Convert to JSON and back
        final json = originalReleaseDate.toJson();
        final deserializedReleaseDate = ReleaseDate.fromJson(json);
        
        expect(deserializedReleaseDate.id, equals(originalReleaseDate.id));
        expect(deserializedReleaseDate.date, equals(originalReleaseDate.date));
        expect(deserializedReleaseDate.human, equals(originalReleaseDate.human));
        expect(deserializedReleaseDate.category, equals(originalReleaseDate.category));
        expect(deserializedReleaseDate.year, equals(originalReleaseDate.year));
        expect(deserializedReleaseDate.month, equals(originalReleaseDate.month));
        expect(deserializedReleaseDate.quarter, equals(originalReleaseDate.quarter));
        expect(deserializedReleaseDate.platform, equals(originalReleaseDate.platform));
        expect(deserializedReleaseDate.region, equals(originalReleaseDate.region));
        expect(deserializedReleaseDate.dateFormat, equals(originalReleaseDate.dateFormat));
      });

      test('should handle null dateFormat in round trip', () {
        final originalReleaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          dateFormat: null,
        );
        
        final json = originalReleaseDate.toJson();
        final deserializedReleaseDate = ReleaseDate.fromJson(json);
        
        expect(deserializedReleaseDate.dateFormat, isNull);
      });
    });

    group('edge cases', () {
      test('should handle zero values correctly', () {
        final releaseDate = ReleaseDate(
          id: 0,
          date: 0,
          year: 0,
          month: 0,
          quarter: 0,
          dateFormat: 0,
        );
        
        expect(releaseDate.id, equals(0));
        expect(releaseDate.date, equals(0));
        expect(releaseDate.year, equals(0));
        expect(releaseDate.month, equals(0));
        expect(releaseDate.quarter, equals(0));
        expect(releaseDate.dateFormat, equals(0));
      });

      test('should handle negative values correctly', () {
        final releaseDate = ReleaseDate(
          id: -1,
          date: -1,
          dateFormat: -1,
        );
        
        expect(releaseDate.id, equals(-1));
        expect(releaseDate.date, equals(-1));
        expect(releaseDate.dateFormat, equals(-1));
      });

      test('should handle very large numbers correctly', () {
        final largeNumber = 4102444800; // Year 2100
        final releaseDate = ReleaseDate(
          id: largeNumber,
          date: largeNumber,
          dateFormat: largeNumber,
        );
        
        expect(releaseDate.id, equals(largeNumber));
        expect(releaseDate.date, equals(largeNumber));
        expect(releaseDate.dateFormat, equals(largeNumber));
      });
    });
  });
}