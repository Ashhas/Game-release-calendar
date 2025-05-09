import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import '../../../domain/enums/filter/date_filter_choice.dart';

class UpcomingGamesState {
  final AsyncValue<Map<DateTime, List<Game>>> games;
  final GameFilter selectedFilters;
  final String nameQuery;

  UpcomingGamesState({
    this.games = const AsyncValue.data({}),
    GameFilter? selectedFilters,
    this.nameQuery = '',
  }) : selectedFilters = selectedFilters ??
            GameFilter(
              releaseDateChoice: DateFilterChoice.allTime,
              platformChoices: {},
              categoryIds: {},
            );

  UpcomingGamesState copyWith({
    AsyncValue<Map<DateTime, List<Game>>>? games,
    GameFilter? selectedFilters,
    String? nameQuery,
  }) {
    return UpcomingGamesState(
      games: games ?? this.games,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      nameQuery: nameQuery ?? this.nameQuery,
    );
  }
}
