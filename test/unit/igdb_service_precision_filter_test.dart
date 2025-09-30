import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/enums/game_category.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';

// Mock repository for testing
class MockIGDBRepository implements IGDBRepository {
  final List<Game> _mockGames;

  const MockIGDBRepository(this._mockGames);

  @override
  Future<List<Game>> getGames(String query) async {
    return _mockGames;
  }
}

void main() {
  group('IGDBService - Release Precision Filtering', () {
    late IGDBService igdbService;
    late List<Game> mockGames;

    setUp(() {
      // Create mock games with various release date scenarios
      mockGames = [
        // Game 1: Exact date (Final Fantasy Tactics scenario)
        Game(
          id: 1,
          createdAt: 1640995200,
          name: 'Final Fantasy Tactics',
          updatedAt: 1640995200,
          url: 'final-fantasy-tactics',
          checksum: 'abc123',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 716132,
              date: 1727654400, // Sep 30, 2025
              human: 'Sep 30, 2025',
              category: null, // IGDB often has null category
              dateFormat: 0, // But dateFormat indicates exact date
            ),
          ],
        ),

        // Game 2: Quarter release (Q1 2025)
        Game(
          id: 2,
          createdAt: 1640995200,
          name: 'Game Q1 2025',
          updatedAt: 1640995200,
          url: 'game-q1-2025',
          checksum: 'def456',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 2,
              human: 'Q1 2025',
              category: ReleaseDateCategory.tbd, // Wrong category
              dateFormat: 4, // Quarter dateFormat
            ),
          ],
        ),

        // Game 3: Quarter release (Q4 2025)
        Game(
          id: 3,
          createdAt: 1640995200,
          name: 'Game Q4 2025',
          updatedAt: 1640995200,
          url: 'game-q4-2025',
          checksum: 'ghi789',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 3,
              human: 'Q4 2025',
              category: null,
              dateFormat: 3, // Quarter dateFormat
            ),
          ],
        ),

        // Game 4: Year-month release
        Game(
          id: 4,
          createdAt: 1640995200,
          name: 'Game March 2025',
          updatedAt: 1640995200,
          url: 'game-march-2025',
          checksum: 'jkl012',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 4,
              human: 'March 2025',
              category: null,
              dateFormat: 1, // Year-month dateFormat
            ),
          ],
        ),

        // Game 5: Year only release
        Game(
          id: 5,
          createdAt: 1640995200,
          name: 'Game 2025',
          updatedAt: 1640995200,
          url: 'game-2025',
          checksum: 'mno345',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 5,
              human: '2025',
              category: ReleaseDateCategory.year,
              dateFormat: 2, // Year dateFormat
            ),
          ],
        ),

        // Game 6: TBD release
        Game(
          id: 6,
          createdAt: 1640995200,
          name: 'Game TBD',
          updatedAt: 1640995200,
          url: 'game-tbd',
          checksum: 'pqr678',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 6,
              human: 'TBD',
              category: ReleaseDateCategory.tbd,
              dateFormat: null,
            ),
          ],
        ),

        // Game 7: Multiple release dates (mixed types)
        Game(
          id: 7,
          createdAt: 1640995200,
          name: 'Game Multi Platform',
          updatedAt: 1640995200,
          url: 'game-multi-platform',
          checksum: 'stu901',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 7,
              date: 1727654400,
              human: 'Sep 30, 2025',
              dateFormat: 0, // Exact date
            ),
            ReleaseDate(
              id: 8,
              human: 'Q1 2026',
              dateFormat: 3, // Quarter
            ),
          ],
        ),

        // Game 8: No release dates
        Game(
          id: 8,
          createdAt: 1640995200,
          name: 'Game No Dates',
          updatedAt: 1640995200,
          url: 'game-no-dates',
          checksum: 'vwx234',
          category: GameCategory.mainGame,
          releaseDates: null,
        ),

        // Game 9: Empty release dates list
        Game(
          id: 9,
          createdAt: 1640995200,
          name: 'Game Empty Dates',
          updatedAt: 1640995200,
          url: 'game-empty-dates',
          checksum: 'yzab567',
          category: GameCategory.mainGame,
          releaseDates: [],
        ),

        // Game 10: Another exact date
        Game(
          id: 10,
          createdAt: 1640995200,
          name: 'Game Exact Date 2',
          updatedAt: 1640995200,
          url: 'game-exact-date-2',
          checksum: 'cdef890',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 10,
              date: 1709251200, // Mar 1, 2024
              human: 'Mar 1, 2024',
              category: ReleaseDateCategory.exactDate,
              dateFormat: 0,
            ),
          ],
        ),
      ];

      final mockRepository = MockIGDBRepository(mockGames);
      igdbService = IGDBService(repository: mockRepository);
    });

    group('all filter', () {
      test('should return all games when filter is all', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.all,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(10)); // All games should be returned
        expect(result.map((g) => g.id).toList(), equals([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]));
      });

      test('should return all games when precision filter is null', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: null,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(10)); // All games should be returned
      });
    });

    group('exactDate filter', () {
      test('should return only games with exact dates', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(3));
        expect(result.map((g) => g.id).toList(), containsAll([1, 7, 10])); // Games with exact dates

        // Verify Final Fantasy Tactics is included (the original bug scenario)
        final finalFantasyTactics = result.firstWhere((game) => game.id == 1);
        expect(finalFantasyTactics.name, equals('Final Fantasy Tactics'));
      });

      test('should include multi-platform game with at least one exact date', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Game 7 has mixed release dates - one exact, one quarter
        // It should be included because it has at least one exact date
        final multiPlatformGame = result.where((game) => game.id == 7);
        expect(multiPlatformGame.length, equals(1));
      });
    });

    group('quarter filter', () {
      test('should return only games with quarter releases', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(3));
        expect(result.map((g) => g.id).toList(), containsAll([2, 3, 7])); // Games with quarter dates
      });

      test('should handle different quarter text patterns', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        final gameNames = result.map((g) => g.name).toList();
        expect(gameNames, contains('Game Q1 2025')); // Q1 pattern
        expect(gameNames, contains('Game Q4 2025')); // Q4 pattern
        expect(gameNames, contains('Game Multi Platform')); // Has quarter release date
      });
    });

    group('yearMonth filter', () {
      test('should return only games with year-month releases', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.yearMonth,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(1));
        expect(result.first.id, equals(4));
        expect(result.first.name, equals('Game March 2025'));
      });
    });

    group('yearOnly filter', () {
      test('should return only games with year-only releases', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.yearOnly,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(1));
        expect(result.first.id, equals(5));
        expect(result.first.name, equals('Game 2025'));
      });
    });

    group('tbd filter', () {
      test('should return only games with TBD releases', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.tbd,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        expect(result.length, equals(1));
        expect(result.map((g) => g.id).toList(), containsAll([6])); // Only games with actual TBD release dates
      });

      test('should only include games with actual TBD release dates', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.tbd,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        final gameNames = result.map((g) => g.name).toList();
        expect(gameNames, contains('Game TBD'));
        // Games with null or empty release dates are excluded by the filtering logic
        expect(gameNames, isNot(contains('Game No Dates')));
        expect(gameNames, isNot(contains('Game Empty Dates')));
      });
    });

    group('edge cases', () {
      test('should handle games with null release dates list', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Game 8 has null release dates - should not appear in exact date filter
        final gameIds = result.map((g) => g.id).toList();
        expect(gameIds, isNot(contains(8)));
      });

      test('should handle games with empty release dates list', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Game 9 has empty release dates list - should not appear in exact date filter
        final gameIds = result.map((g) => g.id).toList();
        expect(gameIds, isNot(contains(9)));
      });

      test('should handle mixed precision types in single game', () async {
        final exactFilter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final quarterFilter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        final exactResult = await igdbService.getGames(nameQuery: null, filter: exactFilter);
        final quarterResult = await igdbService.getGames(nameQuery: null, filter: quarterFilter);

        // Game 7 has both exact and quarter dates - should appear in both filters
        final gameInExact = exactResult.any((g) => g.id == 7);
        final gameInQuarter = quarterResult.any((g) => g.id == 7);

        expect(gameInExact, isTrue);
        expect(gameInQuarter, isTrue);
      });
    });

    group('integration with other filters', () {
      test('should work correctly when combined with name query', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        // This would normally filter by name in a real implementation
        // For this test, we just verify the precision filter still works
        final result = await igdbService.getGames(
          nameQuery: 'Game',
          filter: filter,
        );

        // Should still return quarter games regardless of name query in mock
        expect(result.length, equals(3));
        expect(result.map((g) => g.id).toList(), containsAll([2, 3, 7]));
      });

      test('should work correctly when precision choice is null', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: null,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Should return all games when precision filter is null
        expect(result.length, equals(10));
      });
    });

    group('real-world IGDB data scenarios', () {
      test('should handle Final Fantasy Tactics original bug scenario', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Verify Final Fantasy Tactics appears in exact date filter
        final finalFantasyTactics = result.where((game) =>
          game.name == 'Final Fantasy Tactics' &&
          game.id == 1
        );

        expect(finalFantasyTactics.length, equals(1));

        final game = finalFantasyTactics.first;
        final releaseDate = game.releaseDates!.first;

        // Verify it has the problematic data structure that was fixed
        expect(releaseDate.category, isNull); // Category was null
        expect(releaseDate.dateFormat, equals(0)); // But dateFormat indicates exact
        expect(releaseDate.human, equals('Sep 30, 2025')); // Human text is specific date
      });

      test('should handle quarter with wrong category correctly', () async {
        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        final result = await igdbService.getGames(
          nameQuery: null,
          filter: filter,
        );

        // Game 2 has TBD category but Q1 human text - should be detected as quarter
        final q1Game = result.where((game) => game.name == 'Game Q1 2025');
        expect(q1Game.length, equals(1));

        final game = q1Game.first;
        final releaseDate = game.releaseDates!.first;
        expect(releaseDate.human, equals('Q1 2025'));
        expect(releaseDate.category, equals(ReleaseDateCategory.tbd)); // Wrong category
        expect(releaseDate.dateFormat, equals(4)); // But dateFormat is quarter
      });

      test('should properly prioritize human text over other fields', () async {
        // Test data where human text should override dateFormat and category
        final testGame = Game(
          id: 999,
          createdAt: 1640995200,
          name: 'Test Priority Game',
          updatedAt: 1640995200,
          url: 'test-priority',
          checksum: 'test123',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 999,
              human: 'Q3 2025', // Quarter text (highest priority)
              dateFormat: 0, // Exact format (should be ignored)
              category: ReleaseDateCategory.year, // Year category (should be ignored)
            ),
          ],
        );

        // Add test game to mock data temporarily
        final testRepository = MockIGDBRepository([testGame]);
        final testService = IGDBService(repository: testRepository);

        final quarterFilter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.quarter,
        );

        final exactFilter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final quarterResult = await testService.getGames(nameQuery: null, filter: quarterFilter);
        final exactResult = await testService.getGames(nameQuery: null, filter: exactFilter);

        // Should appear in quarter filter (human text priority)
        expect(quarterResult.length, equals(1));
        expect(quarterResult.first.id, equals(999));

        // Should NOT appear in exact filter
        expect(exactResult.length, equals(0));
      });
    });

    group('performance and boundary conditions', () {
      test('should handle large number of games efficiently', () async {
        // Test with a larger dataset to ensure filtering doesn't have performance issues
        final largeGameList = List.generate(1000, (index) => Game(
          id: index + 1000,
          createdAt: 1640995200,
          name: 'Performance Test Game $index',
          updatedAt: 1640995200,
          url: 'perf-test-$index',
          checksum: 'perf$index',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: index + 1000,
              dateFormat: index % 5, // Cycle through different formats
              category: null,
            ),
          ],
        ));

        final testRepository = MockIGDBRepository(largeGameList);
        final testService = IGDBService(repository: testRepository);

        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final stopwatch = Stopwatch()..start();
        final result = await testService.getGames(nameQuery: null, filter: filter);
        stopwatch.stop();

        // Should complete in reasonable time (less than 100ms for 1000 games)
        expect(stopwatch.elapsedMilliseconds, lessThan(100));

        // Should return correct number of exact date games (dateFormat 0)
        expect(result.length, equals(200)); // Every 5th game has dateFormat 0
      });

      test('should handle empty game list gracefully', () async {
        final emptyRepository = MockIGDBRepository([]);
        final testService = IGDBService(repository: emptyRepository);

        final filter = GameFilter(
          platformChoices: {},
          categoryIds: {},
          releasePrecisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final result = await testService.getGames(nameQuery: null, filter: filter);

        expect(result, isEmpty);
      });
    });
  });
}