import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:riverpod/riverpod.dart';

class UpcomingGamesState {
  final AsyncValue<Map<DateTime, List<Game>>> games;
  final GameFilter selectedFilters;

  UpcomingGamesState({
    this.games = const AsyncValue.data({}),
    GameFilter? selectedFilters,
  }) : selectedFilters = selectedFilters ?? GameFilter();

  UpcomingGamesState copyWith({
    AsyncValue<Map<DateTime, List<Game>>>? games,
    GameFilter? selectedFilters,
  }) {
    return UpcomingGamesState(
      games: games ?? this.games,
      selectedFilters: selectedFilters ?? this.selectedFilters,
    );
  }
}
