import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game_section.dart';
import '../../../domain/enums/filter/date_filter_choice.dart';

class UpcomingGamesState {
  final AsyncValue<List<GameSection>> games;

  /// The currently active filters that will be applied to game queries.
  final GameFilter selectedFilters;

  /// The user's default filters loaded from SharedPrefs at app startup.
  /// Used to determine if filters have changed from defaults (for badge display).
  /// This value should not change during the widget lifecycle.
  final GameFilter initialFilters;

  final String nameQuery;

  UpcomingGamesState({
    this.games = const AsyncValue.data([]),
    GameFilter? selectedFilters,
    GameFilter? initialFilters,
    this.nameQuery = '',
  }) : selectedFilters =
           selectedFilters ??
           GameFilter(
             releaseDateChoice: DateFilterChoice.allTime,
             platformChoices: {},
             categoryIds: {},
           ),
       initialFilters =
           initialFilters ??
           GameFilter(
             releaseDateChoice: DateFilterChoice.allTime,
             platformChoices: {},
             categoryIds: {},
           );

  UpcomingGamesState copyWith({
    AsyncValue<List<GameSection>>? games,
    GameFilter? selectedFilters,
    String? nameQuery,
  }) {
    return UpcomingGamesState(
      games: games ?? this.games,
      selectedFilters: selectedFilters ?? this.selectedFilters,
      initialFilters: initialFilters,
      nameQuery: nameQuery ?? this.nameQuery,
    );
  }
}
