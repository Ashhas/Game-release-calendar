part of '../game_list.dart';

class GameTile extends StatelessWidget {
  final Game game;

  const GameTile({
    required this.game,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final formattedDate = game.firstReleaseDate != null
        ? ConvertFunctions.secondSinceEpochToDateTime(game.firstReleaseDate!)
        : '-';

    return ListTile(
      leading: FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder_210_284.png',
        image: game.cover?.imageId != null
            ? 'https://images.igdb.com/igdb/image/upload/t_logo_med/${game.cover!.imageId}.jpg'
            : 'assets/images/placeholder_210_284.png',
        fadeInDuration: const Duration(milliseconds: 100),
        imageErrorBuilder: (_, __, ___) =>
            Image.asset('assets/images/placeholder_210_284.png'),
      ),
      title: Text(game.name),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Release date: $formattedDate'),
          if (game.platforms != null)
            Wrap(
              spacing: 4.0,
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
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => GameDetailView(game: game),
        ),
      ),
    );
  }
}
