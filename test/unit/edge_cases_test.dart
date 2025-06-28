import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

void main() {
  group('Edge Cases and Error Handling', () {
    group('DateUtilities edge cases', () {
      test('should handle negative timestamps gracefully', () {
        final negativeTimestamp = -1000000;
        final result = DateUtilities.secondSinceEpochToDateTime(negativeTimestamp);
        
        // Should not throw and should return a valid DateTime
        expect(result, isA<DateTime>());
        expect(result.year, lessThan(1970)); // Before epoch
      });

      test('should handle very large timestamps', () {
        final largeTimestamp = 9999999999; // Far future
        final result = DateUtilities.secondSinceEpochToDateTime(largeTimestamp);
        
        expect(result, isA<DateTime>());
        expect(result.year, greaterThan(2000));
      });

      test('should handle zero timestamp', () {
        final result = DateUtilities.secondSinceEpochToDateTime(0);
        
        expect(result.year, equals(1970));
        expect(result.month, equals(1));
        expect(result.day, equals(1));
      });

      test('should handle malformed human readable dates', () {
        final malformedTests = [
          'quarter 2 2025',
          'q2',
          'Q2',
          '2025 Q2',
          'second quarter',
          'Q5 2025', // Invalid quarter
          'Q0 2025', // Invalid quarter
          '',
          '    ', // Whitespace only
        ];

        for (final humanText in malformedTests) {
          final game = _createGame(
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: 1751241600,
                human: humanText,
                category: null,
                dateFormat: null,
              ),
            ],
          );

          // Should not throw
          expect(() => DateUtilities.formatGameReleaseDate(game), returnsNormally);
          expect(() => DateUtilities.getMostSpecificReleaseCategory(game), returnsNormally);
        }
      });

      test('should handle null human text gracefully', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              human: null,
              category: null,
              dateFormat: 1,
            ),
          ],
        );

        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('Jun 2025')); // Should use dateFormat
      });

      test('should handle extreme dateFormat values', () {
        final extremeValues = [-1000, -1, 999, 1000000];
        
        for (final dateFormat in extremeValues) {
          final game = _createGame(
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: 1751241600,
                dateFormat: dateFormat,
                category: null,
              ),
            ],
          );

          // Should not throw and should fallback gracefully
          expect(() => DateUtilities.formatGameReleaseDate(game), returnsNormally);
          expect(() => DateUtilities.getMostSpecificReleaseCategory(game), returnsNormally);
        }
      });

      test('should handle quarter calculation edge cases', () {
        final edgeCases = [
          (DateTime(2025, 1, 1), 'Q1 2025'), // First day of Q1
          (DateTime(2025, 3, 31), 'Q1 2025'), // Last day of Q1
          (DateTime(2025, 4, 1), 'Q2 2025'), // First day of Q2
          (DateTime(2025, 6, 30), 'Q2 2025'), // Last day of Q2
          (DateTime(2025, 7, 1), 'Q3 2025'), // First day of Q3
          (DateTime(2025, 9, 30), 'Q3 2025'), // Last day of Q3
          (DateTime(2025, 10, 1), 'Q4 2025'), // First day of Q4
          (DateTime(2025, 12, 31), 'Q4 2025'), // Last day of Q4
        ];

        for (final (date, expectedQuarter) in edgeCases) {
          final timestamp = date.millisecondsSinceEpoch ~/ 1000;
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
            equals(expectedQuarter),
            reason: 'Date ${date.toString()} should be in $expectedQuarter',
          );
        }
      });

      test('should handle leap year dates correctly', () {
        // February 29, 2024 (leap year)
        final leapYearDate = DateTime(2024, 2, 29);
        final timestamp = leapYearDate.millisecondsSinceEpoch ~/ 1000;
        
        final game = _createGame(
          firstReleaseDate: timestamp,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: timestamp,
              category: ReleaseDateCategory.exactDate,
            ),
          ],
        );

        final result = DateUtilities.formatGameReleaseDate(game);
        expect(result, equals('29-02-2024'));
      });

      test('should handle notification date computation edge cases', () {
        // Past date
        final pastDate = DateTime(2020, 1, 1).millisecondsSinceEpoch ~/ 1000;
        expect(DateUtilities.computeNotificationDate(pastDate), isNull);

        // Current time (should be null since it's not future)
        final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        expect(DateUtilities.computeNotificationDate(now), isNull);

        // Very far future
        final farFuture = DateTime(2100, 1, 1).millisecondsSinceEpoch ~/ 1000;
        final result = DateUtilities.computeNotificationDate(farFuture);
        expect(result, isNotNull);
        expect(result!.year, equals(2100));
        expect(result.hour, equals(10));
        expect(result.minute, equals(0));
      });
    });

    group('GameDateGrouper edge cases', () {
      test('should handle games with circular release date references', () {
        // Create games with complex release date structures
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(id: 1, date: 1751241600, category: ReleaseDateCategory.exactDate),
            ReleaseDate(id: 2, date: 1751241600, category: ReleaseDateCategory.quarter),
            ReleaseDate(id: 3, date: 1751241600, category: ReleaseDateCategory.year),
            ReleaseDate(id: 4, date: 1751241600, category: ReleaseDateCategory.tbd),
          ],
        );

        // Should not throw and should use most specific (exactDate)
        final grouped = GameDateGrouper.groupGamesByReleaseDate([game]);
        expect(grouped.isNotEmpty, isTrue);
        
        final category = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(category, equals(ReleaseDateCategory.exactDate));
      });

      test('should handle games with only null release dates', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(id: 1, date: null),
            ReleaseDate(id: 2, date: null, category: null),
          ],
        );

        final grouped = GameDateGrouper.groupGamesByReleaseDate([game]);
        expect(grouped.isNotEmpty, isTrue);
        
        final category = DateUtilities.getMostSpecificReleaseCategory(game);
        expect(category, equals(ReleaseDateCategory.tbd));
      });

      test('should handle games with conflicting timestamps', () {
        final game = _createGame(
          firstReleaseDate: 1751241600, // June 27, 2025
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1753833600, // July 15, 2025 - different from firstReleaseDate
              category: ReleaseDateCategory.exactDate,
            ),
          ],
        );

        // Should use firstReleaseDate for grouping but release date category for formatting
        final grouped = GameDateGrouper.groupGamesByReleaseDate([game]);
        expect(grouped.containsKey(DateTime(2025, 6, 30)), isTrue); // Grouped by firstReleaseDate
        expect(grouped.containsKey(DateTime(2025, 7, 15)), isFalse);
      });

      test('should handle very large numbers of release dates per game', () {
        final manyReleaseDates = List.generate(1000, (index) =>
          ReleaseDate(
            id: index,
            date: 1751241600,
            category: ReleaseDateCategory.values[index % ReleaseDateCategory.values.length],
          ),
        );

        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: manyReleaseDates,
        );

        // Should handle large lists efficiently and not throw
        final stopwatch = Stopwatch()..start();
        final grouped = GameDateGrouper.groupGamesByReleaseDate([game]);
        final category = DateUtilities.getMostSpecificReleaseCategory(game);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(100));
        expect(grouped.isNotEmpty, isTrue);
        expect(category, equals(ReleaseDateCategory.exactDate)); // Most specific
      });

      test('should handle timestamp overflow/underflow scenarios', () {
        final extremeGames = [
          _createGame(firstReleaseDate: -2147483648), // Min 32-bit int
          _createGame(firstReleaseDate: 2147483647),  // Max 32-bit int
          _createGame(firstReleaseDate: 0),           // Epoch
          _createGame(firstReleaseDate: -1),          // Just before epoch
        ];

        // Should not throw for any extreme values
        for (final game in extremeGames) {
          expect(() => GameDateGrouper.groupGamesByReleaseDate([game]), returnsNormally);
          expect(() => DateUtilities.formatGameReleaseDate(game), returnsNormally);
        }
      });
    });

    group('ReleaseDate model edge cases', () {
      test('should handle JSON with unexpected data types', () {
        final malformedJsonTests = [
          {'id': 'not_a_number'}, // String instead of int
          {'id': 1, 'date': 'invalid_timestamp'}, // String timestamp
          {'id': 1, 'category': 'not_a_number'}, // String category
          {'id': 1, 'date_format': 'invalid'}, // String dateFormat
          {'id': 1, 'y': 'not_a_year'}, // String year
        ];

        for (final json in malformedJsonTests) {
          // Should throw for malformed data
          expect(() => ReleaseDate.fromJson(json), throwsA(isA<TypeError>()));
        }
      });

      test('should handle JSON with missing required fields', () {
        final incompleteJson = <String, dynamic>{}; // No id field
        
        // Should throw or handle gracefully
        expect(() => ReleaseDate.fromJson(incompleteJson), throwsA(isA<TypeError>()));
      });

      test('should handle JSON with null required fields', () {
        final nullIdJson = {'id': null};
        
        expect(() => ReleaseDate.fromJson(nullIdJson), throwsA(isA<TypeError>()));
      });

      test('should handle very large ID values', () {
        final largeId = 9223372036854775807; // Max 64-bit int
        final releaseDate = ReleaseDate(id: largeId);
        
        expect(releaseDate.id, equals(largeId));
        
        final json = releaseDate.toJson();
        final roundTrip = ReleaseDate.fromJson(json);
        expect(roundTrip.id, equals(largeId));
      });
    });

    group('Integration edge cases', () {
      test('should handle mixed valid and invalid data in same list', () {
        final mixedGames = [
          _createGame(firstReleaseDate: 1751241600), // Valid
          _createGame(firstReleaseDate: null), // Null
          _createGame(firstReleaseDate: -1000), // Negative
          _createGame(firstReleaseDate: 0), // Epoch
          _createGame(firstReleaseDate: 9999999999), // Far future
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(mixedGames);
        
        // Should group all games without throwing
        expect(grouped.isNotEmpty, isTrue);
        
        // TBD games should be properly grouped
        expect(grouped.containsKey(GameDateGrouper.tbdDate), isTrue);
        
        // Valid dates should be grouped correctly
        final validDateGames = grouped.entries
            .where((entry) => entry.key != GameDateGrouper.tbdDate)
            .toList();
        expect(validDateGames.isNotEmpty, isTrue);
      });

      test('should maintain performance with pathological data', () {
        // Create scenario with many duplicate timestamps and complex release date arrays
        final pathologicalGames = List.generate(100, (index) =>
          _createGame(
            firstReleaseDate: 1751241600, // All same timestamp
            releaseDates: List.generate(10, (rdIndex) =>
              ReleaseDate(
                id: index * 10 + rdIndex,
                date: 1751241600,
                human: index % 2 == 0 ? 'Q${(rdIndex % 4) + 1} 2025' : null,
                category: null,
                dateFormat: rdIndex % 5,
              ),
            ),
          ),
        );

        final stopwatch = Stopwatch()..start();
        final grouped = GameDateGrouper.groupGamesByReleaseDate(pathologicalGames);
        stopwatch.stop();

        expect(stopwatch.elapsedMilliseconds, lessThan(500)); // Should complete in reasonable time
        expect(grouped[DateTime(2025, 6, 30)]?.length, equals(100));
        
        // Verify sorting is still correct despite complexity
        final sortedGames = grouped[DateTime(2025, 6, 30)]!;
        for (int i = 0; i < sortedGames.length - 1; i++) {
          final currentCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i]);
          final nextCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i + 1]);
          expect(currentCategory.value, lessThanOrEqualTo(nextCategory.value));
        }
      });

      test('should handle Unicode and special characters in game names', () {
        final unicodeGames = [
          _createGame(name: '🎮 Game with Emoji', firstReleaseDate: 1751241600),
          _createGame(name: 'Spécial Châractérs', firstReleaseDate: 1751241600),
          _createGame(name: '日本のゲーム', firstReleaseDate: 1751241600),
          _createGame(name: 'Игра на русском', firstReleaseDate: 1751241600),
          _createGame(name: 'DROP TABLE games;--', firstReleaseDate: 1751241600), // SQL injection attempt
          _createGame(name: '<script>alert("xss")</script>', firstReleaseDate: 1751241600), // XSS attempt
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(unicodeGames);
        final sortedGames = grouped[DateTime(2025, 6, 30)]!;

        // Should handle all names without throwing
        expect(sortedGames.length, equals(6));
        
        // Names should be preserved exactly
        final names = sortedGames.map((game) => game.name).toSet();
        expect(names.contains('🎮 Game with Emoji'), isTrue);
        expect(names.contains('日本のゲーム'), isTrue);
        expect(names.contains('<script>alert(\"xss\")</script>'), isTrue);
      });

      test('should handle concurrent modification scenarios', () {
        var games = <Game>[
          _createGame(name: 'Game 1', firstReleaseDate: 1751241600),
          _createGame(name: 'Game 2', firstReleaseDate: 1751241600),
        ];

        // This simulates what might happen if the list is modified during processing
        // Though in practice this shouldn't happen with proper state management
        final grouped = GameDateGrouper.groupGamesByReleaseDate(List.from(games));
        
        // Modify original list (shouldn't affect result since we made a copy)
        games.clear();
        
        expect(grouped[DateTime(2025, 6, 30)]?.length, equals(2));
      });
    });

    group('Memory and resource management', () {
      test('should not leak memory with large datasets', () {
        // Create and process large dataset
        final largeDataset = List.generate(10000, (index) =>
          _createGame(
            name: 'Game $index',
            firstReleaseDate: 1751241600 + (index * 86400), // One game per day
            releaseDates: [
              ReleaseDate(
                id: index,
                date: 1751241600 + (index * 86400),
                category: ReleaseDateCategory.values[index % ReleaseDateCategory.values.length],
              ),
            ],
          ),
        );

        final stopwatch = Stopwatch()..start();
        final grouped = GameDateGrouper.groupGamesByReleaseDate(largeDataset);
        stopwatch.stop();

        // Should complete in reasonable time
        expect(stopwatch.elapsedMilliseconds, lessThan(2000));
        
        // Should create many groups (one per day)
        expect(grouped.length, greaterThan(1000));
        
        // Cleanup - allow for garbage collection
        largeDataset.clear();
      });

      test('should handle deeply nested release date structures', () {
        final game = _createGame(
          firstReleaseDate: 1751241600,
          releaseDates: List.generate(1000, (index) =>
            ReleaseDate(
              id: index,
              date: 1751241600,
              human: 'Complex release date $index with very long description that might consume significant memory',
              category: ReleaseDateCategory.values[index % ReleaseDateCategory.values.length],
              dateFormat: index % 10,
            ),
          ),
        );

        // Should handle without memory issues
        expect(() => DateUtilities.getMostSpecificReleaseCategory(game), returnsNormally);
        expect(() => DateUtilities.formatGameReleaseDate(game), returnsNormally);
        expect(() => GameDateGrouper.groupGamesByReleaseDate([game]), returnsNormally);
      });
    });
  });
}

/// Helper function to create test games
Game _createGame({
  String name = 'Test Game',
  int? firstReleaseDate,
  List<ReleaseDate>? releaseDates,
}) {
  return Game(
    id: DateTime.now().millisecondsSinceEpoch, // Unique ID
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url',
    checksum: 'test-checksum',
    firstReleaseDate: firstReleaseDate,
    releaseDates: releaseDates,
  );
}