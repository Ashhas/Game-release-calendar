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
          color: Color.fromARGB(255, 255, 255, 255),
          width: 6,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          // reminder.gamePayload.artworks != null
          //     ? reminder.gamePayload.artworks!.first.imageUrl(
          //         size: 'screenshot_med',
          //       )
          //     : reminder.gamePayload.cover!.imageUrl(
          //         size: 'screenshot_big',
          //       ),
          imageUrl,
          height: isVertical ? null : 180,
          //height: double.infinity,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
