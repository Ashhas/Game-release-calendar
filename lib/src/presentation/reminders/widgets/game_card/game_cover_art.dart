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
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: GameImage(
        imageUrl: imageUrl,
        height: isVertical ? null : 180,
        width: double.infinity,
        fit: BoxFit.fill,
      ),
    );
  }
}
