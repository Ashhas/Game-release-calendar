part of '../game_list.dart';

class GameTile extends StatelessWidget {
  const GameTile({
    required this.game,
    super.key,
  });

  final Game game;

  DateTime _fromEpochToDateTime(int? timestamp) {
    return timestamp != null
        ? DateTimeConverter.secondSinceEpochToDateTime(
            timestamp,
          )
        : DateTime.now();
  }

  String _convertDateTimeDay(DateTime dateTime) {
    return DateFormat('dd-MM-yyyy').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage.assetNetwork(
        placeholder: 'assets/images/placeholder_210_284.png',
        image: game.cover != null
            ? game.cover!.imageUrl()
            : Constants.placeholderImageUrl,
        fadeInDuration: const Duration(milliseconds: 100),
        imageErrorBuilder: (_, __, ___) =>
            Image.asset('assets/images/placeholder_210_284.png'),
      ),
      title: Text(game.name),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              'Release date: ${_convertDateTimeDay(_fromEpochToDateTime(game.firstReleaseDate))}'),
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
