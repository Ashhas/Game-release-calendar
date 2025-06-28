import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';

void main() {
  group('DateUtilities', () {
    group('secondSinceEpochToDateTime', () {
      test('should convert epoch seconds to DateTime correctly', () {
        // January 1, 2025 00:00:00 UTC
        final epochSeconds = 1735689600;
        final result = DateUtilities.secondSinceEpochToDateTime(epochSeconds);
        
        expect(result.year, equals(2025));
        expect(result.month, equals(1));
        expect(result.day, equals(1));
        expect(result.hour, equals(0));
        expect(result.minute, equals(0));
        expect(result.second, equals(0));
      });
    });

    group('computeNotificationDate', () {
      test('should return DateTime at 10:00 AM for future dates', () {
        // Future date: December 31, 2025
        final futureEpoch = 1767139200;
        final result = DateUtilities.computeNotificationDate(futureEpoch);
        
        expect(result, isNotNull);
        expect(result!.hour, equals(10));
        expect(result.minute, equals(0));
        expect(result.year, equals(2025));
        expect(result.month, equals(12));
        expect(result.day, equals(31));
      });

      test('should return null for past dates', () {
        // Past date: January 1, 2020
        final pastEpoch = 1577836800;
        final result = DateUtilities.computeNotificationDate(pastEpoch);
        
        expect(result, isNull);
      });
    });

    group('formatReleaseDate', () {
      test('should return TBD when date is null', () {
        final releaseDate = ReleaseDate(
          id: 1,
          date: null,
          category: ReleaseDateCategory.exactDate,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('TBD'));
      });

      test('should format exact date correctly', () {
        // June 27, 2025
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          category: ReleaseDateCategory.exactDate,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, matches(r'\d{2}-\d{2}-2025')); // Format: dd-MM-yyyy
      });

      test('should format year-month correctly', () {
        // June 2025
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          category: ReleaseDateCategory.yearMonth,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('Jun 2025'));
      });

      test('should format quarter correctly', () {
        // Q2 2025 (June)
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600, // June 27, 2025
          category: ReleaseDateCategory.quarter,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('Q2 2025'));
      });

      test('should format year correctly', () {
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          category: ReleaseDateCategory.year,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('2025'));
      });

      test('should return TBD for tbd category', () {
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          category: ReleaseDateCategory.tbd,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('TBD'));
      });

      test('should return TBD for null category', () {
        final releaseDate = ReleaseDate(
          id: 1,
          date: 1751241600,
          category: null,
        );
        
        final result = DateUtilities.formatReleaseDate(releaseDate);
        expect(result, equals('TBD'));
      });
    });

    group('formatGameReleaseDate', () {
      test('should return TBD when firstReleaseDate is null', () {
        final game = _createGame(firstReleaseDate: null);
        
        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('TBD'));
      });

      test('should return TBD when release category is tbd', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: ReleaseDateCategory.tbd,
            ),
          ],
        );
        
        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('TBD'));
      });

      test('should use most specific category when multiple release dates exist', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: ReleaseDateCategory.year, // Less specific
            ),
            ReleaseDate(
              id: 2,
              date: 1751241600,
              category: ReleaseDateCategory.exactDate, // More specific
            ),
          ],
        );
        
        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, matches(r'\d{2}-\d{2}-2025')); // Should use exact date format
      });

      test('should prioritize human-readable quarter format over category', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              human: 'Q2 2025',
              category: ReleaseDateCategory.tbd, // Wrong category
              dateFormat: 4,
            ),
          ],
        );
        
        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('Q2 2025'));
      });

      test('should use dateFormat when category is unreliable', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: ReleaseDateCategory.tbd, // Wrong category
              dateFormat: 1, // Year-month format
            ),
          ],
        );
        
        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('Jun 2025'));
      });

      test('should handle all quarter detection cases', () {
        final quarterTests = [
          ('Q1 2025', DateTime(2025, 2, 15).millisecondsSinceEpoch ~/ 1000, 'Q1 2025'),
          ('q2 2025', DateTime(2025, 5, 15).millisecondsSinceEpoch ~/ 1000, 'Q2 2025'), // Case insensitive
          ('Quarter Q3 2025', DateTime(2025, 8, 15).millisecondsSinceEpoch ~/ 1000, 'Q3 2025'),
          ('q4 coming', DateTime(2025, 11, 15).millisecondsSinceEpoch ~/ 1000, 'Q4 2025'),
        ];

        for (final (humanText, timestamp, expectedQuarter) in quarterTests) {
          final game = _createGame(
            firstReleaseDate: timestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: timestamp,
                human: humanText,
                category: null,
                dateFormat: 4,
              ),
            ],
          );
          
          final result = DateUtilities.formatGameReleaseDate(game);
          expect(result, equals(expectedQuarter), reason: 'Should detect quarter in "$humanText"');
        }
      });
    });

    group('getMostSpecificReleaseCategory', () {
      test('should return tbd when no release dates exist', () {
        final game = _createGame(releaseDates: null);
        
        final result = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(result, equals(ReleaseDateCategory.tbd));
      });

      test('should return tbd when release dates list is empty', () {
        final game = _createGame(releaseDates: []);
        
        final result = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(result, equals(ReleaseDateCategory.tbd));
      });

      test('should return most specific category from multiple release dates', () {
        final game = _createGame(
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: ReleaseDateCategory.year,
            ),
            ReleaseDate(
              id: 2,
              date: 1751241600,
              category: ReleaseDateCategory.exactDate, // Most specific
            ),
            ReleaseDate(
              id: 3,
              date: 1751241600,
              category: ReleaseDateCategory.quarter,
            ),
          ],
        );
        
        final result = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(result, equals(ReleaseDateCategory.exactDate));
      });

      test('should use dateFormat mapping over unreliable category', () {
        final game = _createGame(
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: ReleaseDateCategory.tbd, // Unreliable
              dateFormat: 0, // Exact date
            ),
          ],
        );
        
        final result = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(result, equals(ReleaseDateCategory.exactDate));
      });

      test('should prioritize human-readable quarter detection', () {
        final game = _createGame(
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              human: 'Q2 2025',
              category: ReleaseDateCategory.tbd,
              dateFormat: null,
            ),
          ],
        );
        
        final result = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(result, equals(ReleaseDateCategory.quarter));
      });
    });

    group('dateFormat mapping', () {
      test('should map dateFormat values correctly', () {
        final mappingTests = [
          (0, ReleaseDateCategory.exactDate),
          (1, ReleaseDateCategory.yearMonth),
          (2, ReleaseDateCategory.year),
          (3, ReleaseDateCategory.quarter),
          (4, ReleaseDateCategory.quarter), // Special case based on user data
        ];

        for (final (dateFormat, expectedCategory) in mappingTests) {
          final game = _createGame(
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: 1751241600,
                dateFormat: dateFormat,
              ),
            ],
          );
          
          final result = DateUtilities.getMostSpecificReleaseCategory(game);
          expect(
            result, 
            equals(expectedCategory),
            reason: 'dateFormat $dateFormat should map to ${expectedCategory.name}',
          );
        }
      });
    });

    group('quarter formatting', () {
      test('should format quarters correctly for different months', () {
        final quarterTests = [
          (1, 'Q1'), // January
          (3, 'Q1'), // March
          (4, 'Q2'), // April
          (6, 'Q2'), // June
          (7, 'Q3'), // July
          (9, 'Q3'), // September
          (10, 'Q4'), // October
          (12, 'Q4'), // December
        ];

        for (final (month, expectedQuarter) in quarterTests) {
          final timestamp = DateTime(2025, month, 15).millisecondsSinceEpoch ~/ 1000;
          final game = _createGame(
            firstReleaseDate: timestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: timestamp,
                category: ReleaseDateCategory.quarter,
              ),
            ],
          );
          
          final result = DateUtilities.formatGameReleaseDate(game);
          expect(
            result, 
            equals('$expectedQuarter 2025'),
            reason: 'Month $month should be in $expectedQuarter',
          );
        }
      });
    });
  });
}

/// Helper function to create test games with minimal required fields
Game _createGame({
  int? firstReleaseDate,
  List<ReleaseDate>? releaseDates,
}) {
  return Game(
    id: 1,
    createdAt: 1742318018,
    name: 'Test Game',
    updatedAt: 1742327256,
    url: 'test-url',
    checksum: 'test-checksum',
    firstReleaseDate: firstReleaseDate,
    releaseDates: releaseDates,
  );
}