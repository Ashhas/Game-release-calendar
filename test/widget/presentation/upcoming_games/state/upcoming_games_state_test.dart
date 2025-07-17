import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';

void main() {
  group('UpcomingGamesState', () {
    test('default constructor creates state with correct defaults', () {
      final state = UpcomingGamesState();

      expect(state.games, equals(const AsyncValue.data(<DateTime, List<Game>>{})));
      expect(state.nameQuery, equals(''));
      expect(state.selectedFilters.releaseDateChoice, equals(DateFilterChoice.allTime));
      expect(state.selectedFilters.platformChoices, isEmpty);
      expect(state.selectedFilters.categoryIds, isEmpty);
    });

    test('constructor with custom filters sets them correctly', () {
      final customFilter = GameFilter(
        releaseDateChoice: DateFilterChoice.thisMonth,
        platformChoices: {PlatformFilter.ps5},
        categoryIds: {1, 2, 3},
      );

      final state = UpcomingGamesState(
        selectedFilters: customFilter,
        nameQuery: 'test query',
      );

      expect(state.selectedFilters, equals(customFilter));
      expect(state.nameQuery, equals('test query'));
    });

    test('constructor with games data sets it correctly', () {
      final testGames = <DateTime, List<Game>>{
        DateTime(2025, 1, 1): [_createTestGame(1)],
        DateTime(2025, 1, 2): [_createTestGame(2), _createTestGame(3)],
      };
      final gamesAsyncValue = AsyncValue.data(testGames);

      final state = UpcomingGamesState(games: gamesAsyncValue);

      expect(state.games, equals(gamesAsyncValue));
      state.games.whenData((games) {
        expect(games.length, equals(2));
        expect(games[DateTime(2025, 1, 1)]?.length, equals(1));
        expect(games[DateTime(2025, 1, 2)]?.length, equals(2));
      });
    });

    group('copyWith', () {
      test('creates new instance with updated games', () {
        final initialState = UpcomingGamesState();
        final testGames = <DateTime, List<Game>>{
          DateTime(2025, 1, 1): [_createTestGame(1)],
        };
        final newGamesValue = AsyncValue.data(testGames);

        final updatedState = initialState.copyWith(games: newGamesValue);

        expect(updatedState.games, equals(newGamesValue));
        expect(updatedState.selectedFilters, equals(initialState.selectedFilters));
        expect(updatedState.nameQuery, equals(initialState.nameQuery));
        expect(initialState.games, equals(const AsyncValue.data(<DateTime, List<Game>>{})));
      });

      test('creates new instance with updated filters', () {
        final initialState = UpcomingGamesState();
        final newFilter = GameFilter(
          releaseDateChoice: DateFilterChoice.nextMonth,
          platformChoices: {PlatformFilter.pc},
          categoryIds: {5, 6},
        );

        final updatedState = initialState.copyWith(selectedFilters: newFilter);

        expect(updatedState.selectedFilters, equals(newFilter));
        expect(updatedState.games, equals(initialState.games));
        expect(updatedState.nameQuery, equals(initialState.nameQuery));
      });

      test('creates new instance with updated name query', () {
        final initialState = UpcomingGamesState();
        const newQuery = 'new search query';

        final updatedState = initialState.copyWith(nameQuery: newQuery);

        expect(updatedState.nameQuery, equals(newQuery));
        expect(updatedState.games, equals(initialState.games));
        expect(updatedState.selectedFilters, equals(initialState.selectedFilters));
      });

      test('preserves existing values when parameters are null', () {
        final testGames = <DateTime, List<Game>>{
          DateTime(2025, 1, 1): [_createTestGame(1)],
        };
        final customFilter = GameFilter(
          releaseDateChoice: DateFilterChoice.thisWeek,
          platformChoices: {PlatformFilter.xboxSeries},
          categoryIds: {7, 8, 9},
        );
        
        final initialState = UpcomingGamesState(
          games: AsyncValue.data(testGames),
          selectedFilters: customFilter,
          nameQuery: 'existing query',
        );

        final updatedState = initialState.copyWith();

        expect(updatedState.games, equals(initialState.games));
        expect(updatedState.selectedFilters, equals(initialState.selectedFilters));
        expect(updatedState.nameQuery, equals(initialState.nameQuery));
      });

      test('creates new instance with multiple updated properties', () {
        final initialState = UpcomingGamesState();
        final newGames = <DateTime, List<Game>>{
          DateTime(2025, 1, 1): [_createTestGame(1)],
        };
        final newFilter = GameFilter(
          releaseDateChoice: DateFilterChoice.thisWeek,
          platformChoices: {PlatformFilter.nintendoSwitch},
          categoryIds: {10},
        );
        const newQuery = 'multi-update query';

        final updatedState = initialState.copyWith(
          games: AsyncValue.data(newGames),
          selectedFilters: newFilter,
          nameQuery: newQuery,
        );

        expect(updatedState.games.value, equals(newGames));
        expect(updatedState.selectedFilters, equals(newFilter));
        expect(updatedState.nameQuery, equals(newQuery));
      });
    });

    group('AsyncValue games handling', () {
      test('handles loading state', () {
        const loadingState = AsyncValue<Map<DateTime, List<Game>>>.loading();
        final state = UpcomingGamesState(games: loadingState);

        expect(state.games.isLoading, isTrue);
        expect(state.games.hasValue, isFalse);
        expect(state.games.hasError, isFalse);
      });

      test('handles error state', () {
        final errorState = AsyncValue<Map<DateTime, List<Game>>>.error(
          'Network error',
          StackTrace.current,
        );
        final state = UpcomingGamesState(games: errorState);

        expect(state.games.hasError, isTrue);
        expect(state.games.error, equals('Network error'));
        expect(state.games.hasValue, isFalse);
      });

      test('handles data state with empty games', () {
        const dataState = AsyncValue<Map<DateTime, List<Game>>>.data({});
        final state = UpcomingGamesState(games: dataState);

        expect(state.games.hasValue, isTrue);
        expect(state.games.value, isEmpty);
        expect(state.games.hasError, isFalse);
      });
    });

    group('GameFilter integration', () {
      test('state correctly maintains filter relationships', () {
        final complexFilter = GameFilter(
          releaseDateChoice: DateFilterChoice.next3Months,
          platformChoices: {
            PlatformFilter.ps5,
            PlatformFilter.xboxSeries,
            PlatformFilter.pc,
          },
          categoryIds: {1, 2, 3, 4, 5},
        );

        final state = UpcomingGamesState(selectedFilters: complexFilter);

        expect(state.selectedFilters.releaseDateChoice, equals(DateFilterChoice.next3Months));
        expect(state.selectedFilters.platformChoices.length, equals(3));
        expect(state.selectedFilters.categoryIds.length, equals(5));
        expect(state.selectedFilters.platformChoices.contains(PlatformFilter.ps5), isTrue);
        expect(state.selectedFilters.categoryIds.contains(3), isTrue);
      });
    });
  });
}

Game _createTestGame(int id) {
  return Game(
    id: id,
    createdAt: 1742318018,
    name: 'Test Game $id',
    updatedAt: 1742327256,
    url: 'test-url-$id',
    checksum: 'test-checksum-$id',
    firstReleaseDate: 1751241600,
    cover: Cover(
      id: id,
      imageId: 'test$id',
      url: '//images.igdb.com/igdb/image/upload/t_thumb/test$id.jpg',
    ),
    platforms: [
      Platform(
        id: id,
        name: 'Test Platform $id',
        abbreviation: 'TP$id',
        url: 'platform-url-$id',
      ),
    ],
    releaseDates: [
      ReleaseDate(
        id: id,
        date: 1751241600,
        category: null,
        dateFormat: 0,
      ),
    ],
  );
}