import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/models/game.dart';
import 'package:game_release_calendar/src/services/igdb_service.dart';

class MonthView extends StatefulWidget {
  const MonthView({
    super.key,
  });

  @override
  State<MonthView> createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final gamesList = snapshot.data!;

          return ListView.builder(
            itemCount: gamesList.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: const Image(
                  image: NetworkImage('https://via.placeholder.com/150'),
                  width: 50,
                  height: 50,
                ),
                title: Text(gamesList[index].name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Release date: ${gamesList[index].firstReleaseDate}'),
                    Text('Platforms:  ${gamesList[index].platforms}'),
                  ],
                ),
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
