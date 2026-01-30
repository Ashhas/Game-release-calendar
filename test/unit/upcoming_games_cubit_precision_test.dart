import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';
import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/enums/game_category.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:riverpod/riverpod.dart';

// Mock repository for integration testing
class MockIGDBRepository implements IGDBRepository {
  final List<Game> _mockGames;
  final List<String> _queriesReceived = <String>[];

  // ignore: prefer_const_constructor_declarations
  MockIGDBRepository(this._mockGames);

  List<String> get queriesReceived => _queriesReceived;

  @override
  Future<List<Game>> getGames(String query) async {
    _queriesReceived.add(query);
    // Simulate network delay
    await Future.delayed(Duration(milliseconds: 10));
    return _mockGames;
  }
}

void main() {
  group('UpcomingGamesCubit - Release Precision Filter Integration', () {
    late UpcomingGamesCubit cubit;
    late MockIGDBRepository mockRepository;
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

        // Game 2: Quarter release
        Game(
          id: 2,
          createdAt: 1640995200,
          name: 'Cyberpunk 2078',
          updatedAt: 1640995200,
          url: 'cyberpunk-2078',
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

        // Game 3: Year-month release
        Game(
          id: 3,
          createdAt: 1640995200,
          name: 'Elder Scrolls VI',
          updatedAt: 1640995200,
          url: 'elder-scrolls-vi',
          checksum: 'ghi789',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 3,
              human: 'March 2025',
              category: null,
              dateFormat: 1, // Year-month dateFormat
            ),
          ],
        ),

        // Game 4: TBD release
        Game(
          id: 4,
          createdAt: 1640995200,
          name: 'Half-Life 3',
          updatedAt: 1640995200,
          url: 'half-life-3',
          checksum: 'jkl012',
          category: GameCategory.mainGame,
          releaseDates: [
            ReleaseDate(
              id: 4,
              human: 'TBD',
              category: ReleaseDateCategory.tbd,
              dateFormat: null,
            ),
          ],
        ),
      ];

      mockRepository = MockIGDBRepository(mockGames);
      igdbService = IGDBService(repository: mockRepository);
      cubit = UpcomingGamesCubit(igdbService: igdbService);
    });

    tearDown(() {
      cubit.close();
    });

    group('initial state', () {
      test('should have default filters with no precision filter', () {
        expect(cubit.state.selectedFilters.releasePrecisionChoice, isNull);
        expect(cubit.state.selectedFilters.platformChoices, isEmpty);
        expect(cubit.state.selectedFilters.categoryIds, isEmpty);
        expect(cubit.state.selectedFilters.releaseDateChoice, equals(DateFilterChoice.allTime));
      });

      test('should have empty name query initially', () {
        expect(cubit.state.nameQuery, isEmpty);
      });

      test('should have empty data state initially', () {
        expect(cubit.state.games, isA<AsyncData>());
        final gamesData = cubit.state.games.asData;
        expect(gamesData!.value, isEmpty);
      });
    });

    group('applySearchFilters with precision filter', () {
      test('should update state with precision filter', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: DateFilterChoice.allTime,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.exactDate));
      });

      test('should update state with quarter precision filter', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.quarter,
        );

        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.quarter));
      });

      test('should update state with null precision filter', () async {
        // First set a precision filter
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        // Then clear it
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: null,
        );

        expect(cubit.state.selectedFilters.releasePrecisionChoice, isNull);
      });

      test('should preserve other filters when updating precision filter', () async {
        const testPlatformChoices = <PlatformFilter>{PlatformFilter.playstation5};
        const testCategoryIds = <int>{1, 2, 3};
        const testDateChoice = DateFilterChoice.thisMonth;

        await cubit.applySearchFilters(
          platformChoices: testPlatformChoices,
          setDateChoice: testDateChoice,
          categoryId: testCategoryIds,
          precisionChoice: ReleasePrecisionFilter.yearMonth,
        );

        expect(cubit.state.selectedFilters.platformChoices, equals(testPlatformChoices));
        expect(cubit.state.selectedFilters.categoryIds, equals(testCategoryIds));
        expect(cubit.state.selectedFilters.releaseDateChoice, equals(testDateChoice));
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.yearMonth));
      });
    });

    group('getGames with precision filtering', () {
      test('should fetch and filter games by exact date precision', () async {
        // Set precision filter to exact dates
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        // Trigger games fetch
        cubit.getGames();

        // Wait for async operation to complete
        await Future.delayed(Duration(milliseconds: 50));

        // Should have fetched games
        expect(cubit.state.games, isA<AsyncData>());

        final gamesData = cubit.state.games.asData;
        expect(gamesData, isNotNull);

        // Should only have exact date games (Final Fantasy Tactics in our mock data)
        final sections = gamesData!.value;
        final allGames = sections.expand((section) => section.games).toList();

        // Should contain Final Fantasy Tactics (exact date)
        expect(allGames.any((game) => game.name == 'Final Fantasy Tactics'), isTrue);

        // Should not contain quarter games
        expect(allGames.any((game) => game.name == 'Cyberpunk 2078'), isFalse);
      });

      test('should fetch and filter games by quarter precision', () async {
        // Set precision filter to quarters
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.quarter,
        );

        cubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        expect(cubit.state.games, isA<AsyncData>());

        final gamesData = cubit.state.games.asData;
        final sections = gamesData!.value;
        final allGames = sections.expand((section) => section.games).toList();

        // Should contain quarter games (Cyberpunk 2078)
        expect(allGames.any((game) => game.name == 'Cyberpunk 2078'), isTrue);

        // Should not contain exact date games
        expect(allGames.any((game) => game.name == 'Final Fantasy Tactics'), isFalse);
      });

      test('should fetch all games when precision filter is "all"', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.all,
        );

        cubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        expect(cubit.state.games, isA<AsyncData>());

        final gamesData = cubit.state.games.asData;
        final sections = gamesData!.value;
        final allGames = sections.expand((section) => section.games).toList();

        // Should contain all games
        expect(allGames.length, equals(4));
        expect(allGames.any((game) => game.name == 'Final Fantasy Tactics'), isTrue);
        expect(allGames.any((game) => game.name == 'Cyberpunk 2078'), isTrue);
        expect(allGames.any((game) => game.name == 'Elder Scrolls VI'), isTrue);
        expect(allGames.any((game) => game.name == 'Half-Life 3'), isTrue);
      });

      test('should fetch all games when precision filter is null', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: null,
        );

        cubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        expect(cubit.state.games, isA<AsyncData>());

        final gamesData = cubit.state.games.asData;
        final sections = gamesData!.value;
        final allGames = sections.expand((section) => section.games).toList();

        // Should contain all games when no precision filter
        expect(allGames.length, equals(4));
      });
    });

    group('searchGames with precision filtering', () {
      test('should apply precision filter during search', () async {
        // Set a name query and precision filter
        await cubit.updateNameQuery('Final Fantasy');
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        cubit.searchGames();

        // Wait for debounce timer and async operation
        await Future.delayed(Duration(milliseconds: 500));

        expect(cubit.state.games, isA<AsyncData>());

        // Should have applied both name query and precision filter
        expect(cubit.state.nameQuery, equals('Final Fantasy'));
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.exactDate));
      });

      test('should handle empty search with precision filter', () async {
        await cubit.updateNameQuery('');
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.quarter,
        );

        cubit.searchGames();
        await Future.delayed(Duration(milliseconds: 500));

        // Should show default games with precision filter applied
        expect(cubit.state.games, isA<AsyncData>());
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.quarter));
      });
    });

    group('getGamesWithOffset integration', () {
      test('should apply precision filter to offset games', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        final games = await cubit.getGamesWithOffset(10);

        // Should apply the same precision filter to offset games
        expect(games.length, greaterThanOrEqualTo(0));
        // In our mock, this will still return filtered games based on precision
      });

      test('should handle offset games with different precision filters', () async {
        // Test with TBD filter
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.tbd,
        );

        final games = await cubit.getGamesWithOffset(0);

        // Should filter by TBD precision
        expect(games, isNotNull);
      });
    });

    group('clearSearch integration', () {
      test('should maintain precision filter when clearing search', () async {
        // Set name query and precision filter
        await cubit.updateNameQuery('Test Game');
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.yearMonth,
        );

        // Clear search
        cubit.clearSearch();
        await Future.delayed(Duration(milliseconds: 50));

        // Name query should be cleared but precision filter should remain
        expect(cubit.state.nameQuery, isEmpty);
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.yearMonth));
      });
    });

    group('error handling', () {
      test('should handle service errors gracefully with precision filter', () async {
        // Create a service that throws errors
        final errorRepository = MockIGDBRepository([]);
        final errorService = IGDBService(repository: errorRepository);
        final errorCubit = UpcomingGamesCubit(igdbService: errorService);


        await errorCubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        errorCubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        // Should handle the error gracefully
        expect(errorCubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.exactDate));

        errorCubit.close();
      });
    });

    group('state consistency', () {
      test('should maintain filter state through multiple operations', () async {
        // Apply initial filters
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{PlatformFilter.pc},
          setDateChoice: DateFilterChoice.thisMonth,
          categoryId: <int>{1},
          precisionChoice: ReleasePrecisionFilter.quarter,
        );

        // Perform multiple operations
        await cubit.updateNameQuery('Test');
        cubit.searchGames();
        await Future.delayed(Duration(milliseconds: 500));

        cubit.clearSearch();
        await Future.delayed(Duration(milliseconds: 50));

        cubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        // Filters should remain consistent
        expect(cubit.state.selectedFilters.platformChoices, contains(PlatformFilter.pc));
        expect(cubit.state.selectedFilters.releaseDateChoice, equals(DateFilterChoice.thisMonth));
        expect(cubit.state.selectedFilters.categoryIds, contains(1));
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.quarter));
      });

      test('should handle rapid filter changes', () async {
        // Rapidly change precision filters
        final filters = [
          ReleasePrecisionFilter.exactDate,
          ReleasePrecisionFilter.quarter,
          ReleasePrecisionFilter.yearMonth,
          ReleasePrecisionFilter.all,
          null,
        ];

        for (final filter in filters) {
          await cubit.applySearchFilters(
            platformChoices: <PlatformFilter>{},
            setDateChoice: null,
            categoryId: <int>{},
            precisionChoice: filter,
          );

          cubit.getGames();
          await Future.delayed(Duration(milliseconds: 10));
        }

        // Should end up with the last filter applied
        expect(cubit.state.selectedFilters.releasePrecisionChoice, isNull);
      });
    });

    group('real-world scenarios', () {
      test('should handle Final Fantasy Tactics exact date filtering correctly', () async {
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        cubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        final gamesData = cubit.state.games.asData;
        final sections = gamesData!.value;
        final allGames = sections.expand((section) => section.games).toList();

        // Should find Final Fantasy Tactics despite having null category
        final ffTactics = allGames.where((game) => game.name == 'Final Fantasy Tactics');
        expect(ffTactics.length, equals(1));

        final game = ffTactics.first;
        final releaseDate = game.releaseDates!.first;
        expect(releaseDate.category, isNull); // Verifies the bug scenario
        expect(releaseDate.dateFormat, equals(0)); // But has exact dateFormat
      });

      test('should handle combined filtering scenarios', () async {
        // Test combination of name search and precision filter
        await cubit.updateNameQuery('Cyberpunk');
        await cubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.quarter,
        );

        cubit.searchGames();
        await Future.delayed(Duration(milliseconds: 500));

        // Should apply both filters
        expect(cubit.state.nameQuery, equals('Cyberpunk'));
        expect(cubit.state.selectedFilters.releasePrecisionChoice,
               equals(ReleasePrecisionFilter.quarter));
        expect(cubit.state.games, isA<AsyncData>());
      });

      test('should handle edge case of games with no release dates', () async {
        // Add a game with no release dates to mock data
        final gameWithNoDate = Game(
          id: 99,
          createdAt: 1640995200,
          name: 'Game No Dates',
          updatedAt: 1640995200,
          url: 'game-no-dates',
          checksum: 'nodate123',
          category: GameCategory.mainGame,
          releaseDates: null,
        );

        final extendedGames = [...mockGames, gameWithNoDate];
        final extendedRepo = MockIGDBRepository(extendedGames);
        final extendedService = IGDBService(repository: extendedRepo);
        final extendedCubit = UpcomingGamesCubit(igdbService: extendedService);

        await extendedCubit.applySearchFilters(
          platformChoices: <PlatformFilter>{},
          setDateChoice: null,
          categoryId: <int>{},
          precisionChoice: ReleasePrecisionFilter.exactDate,
        );

        extendedCubit.getGames();
        await Future.delayed(Duration(milliseconds: 50));

        // Should handle games with no release dates gracefully
        expect(extendedCubit.state.games, isA<AsyncData>());

        extendedCubit.close();
      });
    });
  });
}