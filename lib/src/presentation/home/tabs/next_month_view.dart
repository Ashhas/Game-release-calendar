import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/data/igdb_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/section/day_section.dart';

class NextMonthView extends StatefulWidget {
  const NextMonthView({
    super.key,
  });

  @override
  State<NextMonthView> createState() => _NextMonthViewState();
}

class _NextMonthViewState extends State<NextMonthView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getGamesThisMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final groupedGames = _groupGamesByDay(snapshot.data!);

          return ListView.builder(
            itemCount: groupedGames.length,
            itemBuilder: (_, int index) {
              final dayWithList = groupedGames.entries.elementAt(index);

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DaySection(
                    groupedGames: dayWithList,
                  ),
                  const Divider(
                    thickness: 1,
                  ),
                ],
              );
            },
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Map<DateTime, List<Game>> _groupGamesByDay(List<Game> games) {
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
