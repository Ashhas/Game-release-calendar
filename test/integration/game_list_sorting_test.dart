import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';

void main() {
  group('Game List Sorting Integration Tests', () {
    group('same-day sorting behavior', () {
      testWidgets('should sort games by category specificity on same day', (WidgetTester tester) async {
        final sameTimestamp = 1751241600; // June 27, 2025
        final games = [
          _createGame(
            id: 1,
            name: 'TBD Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: sameTimestamp,
                category: null,
                dateFormat: null, // No format info = TBD
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Year Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: sameTimestamp,
                category: null,
                dateFormat: 2, // Year only
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'Exact Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: sameTimestamp,
                category: null,
                dateFormat: 0, // Exact date
              ),
            ],
          ),
          _createGame(
            id: 4,
            name: 'Quarter Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 4,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4, // Quarter
              ),
            ],
          ),
          _createGame(
            id: 5,
            name: 'Month Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 5,
                date: sameTimestamp,
                category: null,
                dateFormat: 1, // Year-month
              ),
            ],
          ),
        ];

        // Group and sort using the actual app logic
        final grouped = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        // Verify the sorting order matches expected category specificity
        expect(sortedGames[0].name, equals('Exact Game')); // Most specific
        expect(sortedGames[1].name, equals('Month Game'));
        expect(sortedGames[2].name, equals('Quarter Game'));
        expect(sortedGames[3].name, equals('Year Game'));
        expect(sortedGames[4].name, equals('TBD Game')); // Least specific

        // Verify that the display format matches the sorting logic
        for (int i = 0; i < sortedGames.length - 1; i++) {
          final currentCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i]);
          final nextCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i + 1]);
          
          expect(
            currentCategory.value,
            lessThanOrEqualTo(nextCategory.value),
            reason: 'Game at position $i should be more specific than game at position ${i + 1}',
          );
        }
      });

      testWidgets('should sort alphabetically within same category', (WidgetTester tester) async {
        final sameTimestamp = 1751241600;
        final games = [
          _createGame(
            id: 1,
            name: 'Zelda Quarter Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Alpha Quarter Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'Beta Quarter Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        expect(sortedGames[0].name, equals('Alpha Quarter Game'));
        expect(sortedGames[1].name, equals('Beta Quarter Game'));
        expect(sortedGames[2].name, equals('Zelda Quarter Game'));
      });

      testWidgets('should sort by formatted string within same category', (WidgetTester tester) async {
        final games = [
          _createGame(
            id: 1,
            name: 'Game A',
            firstReleaseDate: DateTime(2025, 12, 15).millisecondsSinceEpoch ~/ 1000, // Q4
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: DateTime(2025, 12, 15).millisecondsSinceEpoch ~/ 1000,
                human: 'Q4 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Game B',
            firstReleaseDate: DateTime(2025, 4, 15).millisecondsSinceEpoch ~/ 1000, // Q2
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: DateTime(2025, 4, 15).millisecondsSinceEpoch ~/ 1000,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'Game C',
            firstReleaseDate: DateTime(2025, 1, 15).millisecondsSinceEpoch ~/ 1000, // Q1
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: DateTime(2025, 1, 15).millisecondsSinceEpoch ~/ 1000,
                human: 'Q1 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
        ];

        // All games released on same day for this test
        final sameDayGames = games.map((game) => 
          _createGame(
            id: game.id,
            name: game.name,
            firstReleaseDate: 1751241600, // Same day
            releaseDates: game.releaseDates,
          ),
        ).toList();

        final grouped = GameDateGrouper.groupGamesByReleaseDate(sameDayGames);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        // Should sort by formatted quarter string: Q1, Q2, Q4
        final formattedStrings = sortedGames.map((game) => 
          DateUtilities.formatGameReleaseDate(game)
        ).toList();

        expect(formattedStrings[0], equals('Q1 2025'));
        expect(formattedStrings[1], equals('Q2 2025'));
        expect(formattedStrings[2], equals('Q4 2025'));
      });
    });

    group('cross-day sorting behavior', () {
      testWidgets('should sort different dates chronologically', (WidgetTester tester) async {
        final games = [
          _createGame(
            id: 1,
            name: 'Future Game',
            firstReleaseDate: 1753833600, // July 15, 2025
          ),
          _createGame(
            id: 2,
            name: 'Earlier Game',
            firstReleaseDate: 1751241600, // June 27, 2025
          ),
          _createGame(
            id: 3,
            name: 'Latest Game',
            firstReleaseDate: 1756425600, // August 28, 2025
          ),
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedDates = grouped.keys.toList()..sort();

        expect(sortedDates[0], equals(DateTime(2025, 6, 27)));
        expect(sortedDates[1], equals(DateTime(2025, 7, 15)));
        expect(sortedDates[2], equals(DateTime(2025, 8, 28)));
      });

      testWidgets('should place TBD games in special section', (WidgetTester tester) async {
        final games = [
          _createGame(
            id: 1,
            name: 'Valid Date Game',
            firstReleaseDate: 1751241600,
          ),
          _createGame(
            id: 2,
            name: 'TBD Game',
            firstReleaseDate: null,
          ),
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(games);

        expect(grouped.containsKey(DateTime(2025, 6, 27)), isTrue);
        expect(grouped.containsKey(GameDateGrouper.tbdDate), isTrue);
        expect(grouped[GameDateGrouper.tbdDate]!.length, equals(1));
        expect(grouped[GameDateGrouper.tbdDate]!.first.name, equals('TBD Game'));
      });
    });

    group('real-world scenarios', () {
      testWidgets('should handle user reported issue correctly', (WidgetTester tester) async {
        // This represents the original user issue that was fixed
        final problemGame = _createGame(
          id: 302610,
          name: 'Originally TBD Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 716132,
              date: 1751241600,
              human: 'Q2 2025',
              category: null, // Originally was category 4 (TBD)
              year: 2025,
              month: 6,
              dateFormat: 4,
            ),
          ],
        );

        final otherGames = [
          _createGame(
            id: 1,
            name: 'Exact Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: 1751241600,
                category: null,
                dateFormat: 0,
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Year Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: 1751241600,
                category: null,
                dateFormat: 2,
              ),
            ],
          ),
        ];

        final allGames = [problemGame, ...otherGames];
        final grouped = GameDateGrouper.groupGamesByReleaseDate(allGames);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        // The originally problematic game should now display correctly and be sorted properly
        expect(
          DateUtilities.formatGameReleaseDate(problemGame),
          equals('Q2 2025'),
          reason: 'Should show Q2 2025 instead of TBD',
        );

        // Should be sorted: Exact Game, Originally TBD Game (quarter), Year Game
        expect(sortedGames[0].name, equals('Exact Game'));
        expect(sortedGames[1].name, equals('Originally TBD Game'));
        expect(sortedGames[2].name, equals('Year Game'));
      });

      testWidgets('should handle mixed data quality from IGDB correctly', (WidgetTester tester) async {
        final mixedQualityGames = [
          // Good data - exact date
          _createGame(
            id: 1,
            name: 'AAA Studio Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: 1751241600,
                human: 'June 27, 2025',
                category: null,
                dateFormat: 0,
              ),
            ],
          ),
          // Poor data - conflicting info, but human format saves it
          _createGame(
            id: 2,
            name: 'Indie Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: 1751241600,
                human: 'Q2 2025',
                category: null, // Would be TBD
                dateFormat: 4,
              ),
            ],
          ),
          // Minimal data - only year known
          _createGame(
            id: 3,
            name: 'Early Access Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: 1751241600,
                human: '2025',
                category: null,
                dateFormat: 2,
              ),
            ],
          ),
          // No reliable data
          _createGame(
            id: 4,
            name: 'Mysterious Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 4,
                date: 1751241600,
                category: null,
                dateFormat: null,
              ),
            ],
          ),
        ];

        final grouped = GameDateGrouper.groupGamesByReleaseDate(mixedQualityGames);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        // Should sort by data quality/specificity
        expect(sortedGames[0].name, equals('AAA Studio Game')); // Exact date
        expect(sortedGames[1].name, equals('Indie Game')); // Quarter
        expect(sortedGames[2].name, equals('Early Access Game')); // Year
        expect(sortedGames[3].name, equals('Mysterious Game')); // TBD

        // Verify display formats are correct
        expect(DateUtilities.formatGameReleaseDate(sortedGames[0]), contains('27-06-2025'));
        expect(DateUtilities.formatGameReleaseDate(sortedGames[1]), equals('Q2 2025'));
        expect(DateUtilities.formatGameReleaseDate(sortedGames[2]), equals('2025'));
        expect(DateUtilities.formatGameReleaseDate(sortedGames[3]), equals('TBD'));
      });

      testWidgets('should maintain consistent sorting with multiple platforms', (WidgetTester tester) async {
        final multiPlatformGame = _createGame(
          id: 1,
          name: 'Multi-Platform Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            // PC release - exact date
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: null,
              dateFormat: 0,
            ),
            // Console release - quarter
            ReleaseDate(
              id: 2,
              date: 1751241600,
              human: 'Q2 2025',
              category: null,
              dateFormat: 4,
            ),
            // Mobile release - year only
            ReleaseDate(
              id: 3,
              date: 1751241600,
              category: null,
              dateFormat: 2,
            ),
          ],
        );

        final singlePlatformGames = [
          _createGame(
            id: 2,
            name: 'Console Only Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 4,
                date: 1751241600,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'PC Only Game',
            firstReleaseDate: 1751241600,
            releaseDates: [
              ReleaseDate(
                id: 5,
                date: 1751241600,
                category: null,
                dateFormat: 2, // Year only
              ),
            ],
          ),
        ];

        final allGames = [multiPlatformGame, ...singlePlatformGames];
        final grouped = GameDateGrouper.groupGamesByReleaseDate(allGames);
        final sortedGames = grouped[DateTime(2025, 6, 27)]!;

        // Multi-platform game should use most specific release date (exact date)
        expect(sortedGames[0].name, equals('Multi-Platform Game'));
        expect(DateUtilities.formatGameReleaseDate(sortedGames[0]), contains('27-06-2025'));

        // Other games sorted by their precision
        expect(sortedGames[1].name, equals('Console Only Game')); // Quarter
        expect(sortedGames[2].name, equals('PC Only Game')); // Year
      });
    });

    group('performance and edge cases', () {
      testWidgets('should handle large numbers of games efficiently', (WidgetTester tester) async {
        final manyGames = List.generate(100, (index) =>
          _createGame(
            id: index,
            name: 'Game $index',
            firstReleaseDate: 1751241600, // All same day
            releaseDates: [
              ReleaseDate(
                id: index,
                date: 1751241600,
                category: null,
                dateFormat: index % 5, // Distribute across all categories
              ),
            ],
          ),
        );

        final stopwatch = Stopwatch()..start();
        final grouped = GameDateGrouper.groupGamesByReleaseDate(manyGames);
        stopwatch.stop();

        // Should complete quickly
        expect(stopwatch.elapsedMilliseconds, lessThan(100));

        final sortedGames = grouped[DateTime(2025, 6, 27)]!;
        expect(sortedGames.length, equals(100));

        // Verify sorting is correct - games with lower dateFormat should come first
        for (int i = 0; i < sortedGames.length - 1; i++) {
          final currentCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i]);
          final nextCategory = DateUtilities.getMostSpecificReleaseCategory(sortedGames[i + 1]);
          
          expect(currentCategory.value, lessThanOrEqualTo(nextCategory.value));
        }
      });

      testWidgets('should handle empty game lists gracefully', (WidgetTester tester) async {
        final grouped = GameDateGrouper.groupGamesByReleaseDate([]);
        expect(grouped, isEmpty);
      });

      testWidgets('should handle all games with null dates', (WidgetTester tester) async {
        final nullDateGames = List.generate(5, (index) =>
          _createGame(
            id: index,
            name: 'TBD Game $index',
            firstReleaseDate: null,
          ),
        );

        final grouped = GameDateGrouper.groupGamesByReleaseDate(nullDateGames);
        
        expect(grouped.length, equals(1));
        expect(grouped.containsKey(GameDateGrouper.tbdDate), isTrue);
        expect(grouped[GameDateGrouper.tbdDate]!.length, equals(5));
      });
    });
  });
}

/// Helper function to create test games
Game _createGame({
  required int id,
  required String name,
  int? firstReleaseDate,
  List<ReleaseDate>? releaseDates,
}) {
  return Game(
    id: id,
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url-$id',
    checksum: 'test-checksum-$id',
    firstReleaseDate: firstReleaseDate,
    releaseDates: releaseDates,
  );
}