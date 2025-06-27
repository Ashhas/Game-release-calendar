part of 'game_card.dart';

class GameCoverArt extends StatelessWidget {
  const GameCoverArt({
    super.key,
    required this.imageUrl,
    required this.isVertical,
  });

  final String imageUrl;
  final bool isVertical;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          width: 6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: GameImage(
          imageUrl: imageUrl,
          height: isVertical ? null : 180,
          width: double.infinity,
        ),
      ),
    );
  }
}
