part of '../../game_list.dart';

class GameTile extends StatelessWidget {
  const GameTile({
    required this.game,
    this.isTbd = false,
    super.key,
  });

  final Game game;
  final bool isTbd;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: isTbd
          ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.3)
          : null,
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 94,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: FadeInImage.assetNetwork(
              placeholder: 'assets/images/placeholder_210_284.png',
              image: game.cover != null
                  ? game.cover!.imageUrl()
                  : Constants.placeholderImageUrl,
              fadeInDuration: const Duration(milliseconds: 100),
              fit: BoxFit.cover,
              imageErrorBuilder: (_, __, ___) => Image.asset(
                'assets/images/placeholder_210_284.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(game.name),
        subtitle: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Release date: ${DateUtilities.formatGameReleaseDate(game)}'),
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
      ),
    );
  }
}
