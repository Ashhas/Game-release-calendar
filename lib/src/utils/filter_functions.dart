import 'package:game_release_calendar/src/domain/models/game.dart';

/// Holds filter functions to be used thoughout the app
class FilterFunctions {
  static Map<DateTime, List<Game>> groupGamesByDay(List<Game> games) {
    Map<DateTime, List<Game>> groupedGames = {};

    for (final game in games) {
      if (game.firstReleaseDate != null) {
        final releaseDate = DateTime.fromMillisecondsSinceEpoch(
          game.firstReleaseDate! * 1000,
        );

        final dateWithoutTime = DateTime(
          releaseDate.year,
          releaseDate.month,
          releaseDate.day,
        );

        // If the date is not in the map, add new entry for it
        if (!groupedGames.containsKey(dateWithoutTime)) {
          groupedGames[dateWithoutTime] = [];
        }

        // Add the game to the list of games for that day
        groupedGames[dateWithoutTime]?.add(game);
      }
    }

    return groupedGames;
  }
}
