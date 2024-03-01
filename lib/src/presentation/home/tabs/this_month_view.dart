import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/data/igdb_service.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/game_tile.dart';

class ThisMonthView extends StatefulWidget {
  const ThisMonthView({
    super.key,
  });

  @override
  State<ThisMonthView> createState() => _ThisMonthViewState();
}

class _ThisMonthViewState extends State<ThisMonthView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getGamesThisMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final gamesList = snapshot.data!;

          return ListView.builder(
            itemCount: gamesList.length,
            itemBuilder: (context, index) {
              return GameTile(
                game: gamesList[index],
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
}
