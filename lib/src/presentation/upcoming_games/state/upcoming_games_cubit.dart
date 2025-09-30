import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

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
  })  : _igdbService = igdbService,
        super(UpcomingGamesState());

  final IGDBService _igdbService;
  Timer? _debounce;

  void getGames() async {
    _fetchGames();
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
  }

  /// Default function to fetch games from IGDB API and update state
  void _fetchGames() async {
    emit(state.copyWith(games: const AsyncValue.loading()));

    try {
      final games = await _igdbService.getGames(
        nameQuery: state.nameQuery,
        filter: state.selectedFilters,
      );
      final filteredList = GameDateGrouper.groupGamesByReleaseDate(games);
      emit(state.copyWith(games: AsyncValue.data(filteredList)));
    } catch (e) {
      emit(state.copyWith(games: AsyncValue.error(e, StackTrace.current)));
    }
  }
}
