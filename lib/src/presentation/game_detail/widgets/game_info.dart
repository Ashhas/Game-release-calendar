part of '../game_detail_view.dart';

class GameInfo extends StatelessWidget {
  const GameInfo({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  Widget build(BuildContext context) {
    final formattedDate = game.firstReleaseDate != null
        ? ConvertFunctions.secondSinceEpochToDateTime(game.firstReleaseDate!)
        : '-';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Image(
            image: NetworkImage(
              'https://images.igdb.com/igdb/image/upload/t_logo_med/${game.cover?.imageId}.jpg',
            ) as ImageProvider,
          ),
        ),
        Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.spacings.xs,
                vertical: context.spacings.xs,
              ),
              child: SpacedColumn(
                spacing: context.spacings.xxs,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: const TextStyle(fontSize: 25),
                  ),
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
            )),
      ],
    );
  }
}
