import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/analytics_service.dart';
import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';
import '../../../domain/enums/filter/date_filter_choice.dart';
import '../../../domain/enums/filter/platform_filter.dart';
import '../../../domain/enums/filter/release_precision_filter.dart';

class UpcomingGamesCubit extends Cubit<UpcomingGamesState> {
  UpcomingGamesCubit({
    required IGDBService igdbService,
    AnalyticsService? analyticsService,
  })  : _igdbService = igdbService,
        _analyticsService = analyticsService,
        super(UpcomingGamesState());

  final IGDBService _igdbService;
  final AnalyticsService? _analyticsService;
  Timer? _debounce;

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> getGames() async {
    await _fetchGames();
  }

  /// Based on search-input, fetch games from IGDB API
  void searchGames() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () async {
      if (state.nameQuery.isEmpty) {
        // Show default games
        getGames();
        return;
      }

      // Track search only for non-empty queries
      _analyticsService?.trackSearchPerformed(query: state.nameQuery);

      _fetchGames();
    });
  }

  /// Method to extend the games list with the same filters
  Future<List<Game>> getGamesWithOffset(int offset) async {
    try {
      final games = await _igdbService.getGames(
        nameQuery: state.nameQuery,
        filter: state.selectedFilters,
        offset: offset,
      );

      return games;
    } catch (e) {
      if (e is AppException) {
        emit(state.copyWith(games: AsyncValue.error(e, StackTrace.current)));
      }
      return [];
    }
  }

  Future<void> updateNameQuery(String query) async {
    emit(state.copyWith(nameQuery: query));
  }

  void clearSearch() {
    emit(state.copyWith(nameQuery: ''));
    getGames();
  }

  Future<void> applySearchFilters({
    required Set<PlatformFilter> platformChoices,
    required DateFilterChoice? setDateChoice,
    required Set<int> categoryId,
    ReleasePrecisionFilter? precisionChoice,
  }) async {
    emit(
      state.copyWith(
        selectedFilters: state.selectedFilters.copyWith(
          platformChoices: platformChoices,
          categoryIds: categoryId,
          releaseDateChoice: setDateChoice,
          releasePrecisionChoice: precisionChoice,
        ),
      ),
    );

    _analyticsService?.trackFilterApplied(
      platforms: platformChoices.map((p) => p.name).toList(),
      dateFilter: setDateChoice?.name,
      categoryIds: categoryId.toList(),
      precisionFilter: precisionChoice?.name,
    );
  }

  /// Default function to fetch games from IGDB API and update state
  Future<void> _fetchGames() async {
    emit(state.copyWith(games: const AsyncValue.loading()));

    try {
      final games = await _igdbService.getGames(
        nameQuery: state.nameQuery,
        filter: state.selectedFilters,
      );
      final sections = GameDateGrouper.groupGamesIntoSections(games);
      emit(state.copyWith(games: AsyncValue.data(sections)));
    } catch (e) {
      emit(state.copyWith(games: AsyncValue.error(e, StackTrace.current)));
    }
  }
}
