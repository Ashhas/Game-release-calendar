import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/game_detail_view.dart';

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
      leading: FadeInImage(
        placeholder: const AssetImage('assets/images/placeholder_210_284.png'),
        fadeInDuration: const Duration(milliseconds: 100),
        image: NetworkImage(
          game.cover?.imageId != null
              ? 'https://images.igdb.com/igdb/image/upload/t_logo_med/${game.cover?.imageId}.jpg'
              : 'https://via.placeholder.com/150',
        ),
        imageErrorBuilder: (_, __, ___) {
          return Image.asset('assets/images/placeholder_210_284.png');
        },
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
                    label: Text(
                      platform.abbreviation ?? platform.name ?? 'N/A',
                    ),
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                  ),
                )
                .toList(),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GameDetailView(
              game: game,
            ),
          ),
        );
      },
    );
  }
}
