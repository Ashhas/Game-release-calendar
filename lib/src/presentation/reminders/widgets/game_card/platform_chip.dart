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
          horizontal: 6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(6),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Text(
          platformAbbreviation,
          style: Theme.of(context).textTheme.labelMedium,
        ),
      ),
    );
  }
}
