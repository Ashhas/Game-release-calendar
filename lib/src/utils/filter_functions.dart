import 'package:game_release_calendar/src/domain/models/game.dart';

/// Holds filter functions to be used throughout the app
class FilterFunctions {
  static Map<DateTime, List<Game>> filterAllGames(List<Game> games) {
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

  static Map<DateTime, List<Game>> filterGamesForCurrentMonth(
      List<Game> games) {
    Map<DateTime, List<Game>> groupedGames = {};

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);

    for (final game in games) {
      if (game.firstReleaseDate != null) {
        final releaseDate = DateTime.fromMillisecondsSinceEpoch(
          game.firstReleaseDate! * 1000,
        );

        if (releaseDate.isAfter(startOfMonth) &&
            releaseDate.isBefore(endOfMonth)) {
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
    }

    return groupedGames;
  }

  static Map<DateTime, List<Game>> filterGamesForNextMonth(List<Game> games) {
    Map<DateTime, List<Game>> groupedGames = {};

    final now = DateTime.now();
    final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
    final endOfNextMonth =
        DateTime(now.year, now.month + 2, 0, 23, 59, 59, 999);

    for (final game in games) {
      if (game.firstReleaseDate != null) {
        final releaseDate = DateTime.fromMillisecondsSinceEpoch(
          game.firstReleaseDate! * 1000,
        );

        if (releaseDate.isAfter(startOfNextMonth) &&
            releaseDate.isBefore(endOfNextMonth)) {
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
    }

    return groupedGames;
  }
}
