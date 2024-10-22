import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/domain/enums/date_filter_choice.dart';
import 'package:game_release_calendar/src/domain/enums/platform_filter_choice.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/utils/filter_functions.dart';

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
      final filteredList = FilterFunctions.groupGamesByReleaseDate(games);
      emit(state.copyWith(games: AsyncValue.data(filteredList)));
    } catch (e) {
      emit(state.copyWith(games: AsyncValue.error(e, StackTrace.current)));
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
    required PlatformFilterChoice? choice,
  }) async {
    emit(
      state.copyWith(
        selectedFilters: state.selectedFilters.copyWith(
          platform: choice,
        ),
      ),
    );
  }
}
