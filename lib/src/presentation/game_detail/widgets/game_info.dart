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
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 250, 
          child: AspectRatio(
            aspectRatio: 249 / 374, // 0.666 ratio
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(12)),
              child: GameImage(
                imageUrl: widget.game.cover != null
                    ? widget.game.cover!.imageUrl()
                    : Constants.placeholderImageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(context.spacings.xs),
          child: SpacedColumn(
            spacing: context.spacings.xxs,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.game.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 24),
              ),
              if (widget.game.platforms != null &&
                  widget.game.platforms!.isNotEmpty)
                Wrap(
                  spacing: context.spacings.xxs,
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
                )
              else
                const Text(
                  'Platform information not available',
                  style: TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
