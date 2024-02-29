import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/widgets/game_tile.dart';
import 'package:game_release_calendar/src/services/igdb_service.dart';

class OncomingMonthView extends StatefulWidget {
  const OncomingMonthView({
    super.key,
  });

  @override
  State<OncomingMonthView> createState() => _OncomingMonthViewState();
}

class _OncomingMonthViewState extends State<OncomingMonthView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getOncomingGamesThisMonth(),
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
