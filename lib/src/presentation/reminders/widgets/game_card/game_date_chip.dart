part of 'game_card.dart';

class PlatformChip extends StatelessWidget {
  const PlatformChip({
    super.key,
    required this.platformAbbreviation,
  });

  final String platformAbbreviation;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 8,
          vertical: 4,
        ),
        decoration: BoxDecoration(
          //color: Color.fromARGB(255, 255, 255, 255),
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Text(
          platformAbbreviation,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
