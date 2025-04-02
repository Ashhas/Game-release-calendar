import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

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
  void searchGames(String query) {
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
      return [];
    }
  }

  Future<void> updateNameQuery(String query) async {
    emit(state.copyWith(nameQuery: query));
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
