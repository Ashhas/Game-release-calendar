import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/domain/enums/filter/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/filter/platform_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

class UpcomingGamesCubit extends Cubit<UpcomingGamesState> {
  UpcomingGamesCubit({
    required IGDBService igdbService,
  })  : _igdbService = igdbService,
        super(UpcomingGamesState());

  final IGDBService _igdbService;

  void getGames() async {
    emit(state.copyWith(games: const AsyncValue.loading()));

    try {
      final games = await _igdbService.getGames(state.selectedFilters);
      final filteredList = GameDateGrouper.groupGamesByReleaseDate(games);
      emit(state.copyWith(games: AsyncValue.data(filteredList)));
    } catch (e) {
      emit(state.copyWith(games: AsyncValue.error(e, StackTrace.current)));
    }
  }

  /// Method to extend the games list with the same filters
  Future<List<Game>> getGamesWithOffset(int offset) async {
    try {
      final games = await _igdbService.getGamesWithOffset(
        filter: state.selectedFilters,
        offset: offset,
      );

      return games;
    } catch (e) {
      return [];
    }
  }

  Future<void> updateDateFilter({
    required DateFilterChoice? choice,
    required DateTimeRange? range,
  }) async {
    emit(
      state.copyWith(
        selectedFilters: state.selectedFilters.copyWith(
          releaseDateChoice: choice,
          releaseDateRange: range,
        ),
      ),
    );
  }

  Future<void> updatePlatformFilter({
    required Set<PlatformFilter> choices,
  }) async {
    emit(
      state.copyWith(
        selectedFilters: state.selectedFilters.copyWith(
          platformChoices: choices,
        ),
      ),
    );
  }
}
