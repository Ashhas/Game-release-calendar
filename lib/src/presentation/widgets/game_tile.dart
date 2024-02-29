import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/models/game.dart';
import 'package:intl/intl.dart';

class GameTile extends StatelessWidget {
  final Game game;

  const GameTile({
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = game.firstReleaseDate != null
        ? DateFormat('dd-MM-yyyy').format(
            DateTime.fromMillisecondsSinceEpoch(
              game.firstReleaseDate! * 1000,
            ),
          )
        : '-';

    return ListTile(
      leading: Image(
        image: NetworkImage(
          game.cover?.url ?? 'https://via.placeholder.com/150',
        ),
      ),
      title: Text(game.name),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Release date: $formattedDate'),
          Wrap(
            spacing: 4.0,
            runSpacing: 0,
            children: game.platforms!
                .map(
                  (platform) => Chip(
                    label: Text(platform.abbreviation ?? ''),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
