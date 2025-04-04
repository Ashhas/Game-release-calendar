part of '../game_detail_view.dart';

class GameInfo extends StatefulWidget {
  const GameInfo({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<GameInfo> createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          flex: 1,
          child: Image(
            image: NetworkImage(
              widget.game.cover != null
                  ? widget.game.cover!.imageUrl()
                  : Constants.placeholderImageUrl,
            ) as ImageProvider,
          ),
        ),
        Flexible(
          flex: 2,
          child: Padding(
            padding: EdgeInsets.all(context.spacings.xs),
            child: SpacedColumn(
              spacing: context.spacings.xxs,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.game.name,
                  style: const TextStyle(fontSize: 24),
                ),
                Wrap(
                  spacing: 4.0,
                  runSpacing: 0,
                  children: widget.game.platforms!
                      .map(
                        (platform) => Chip(
                          label: Text(
                            platform.abbreviation ?? platform.name ?? 'N/A',
                          ),
                          visualDensity: VisualDensity(
                            horizontal: VisualDensity.minimumDensity,
                            vertical: VisualDensity.minimumDensity,
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      )
                      .toList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
