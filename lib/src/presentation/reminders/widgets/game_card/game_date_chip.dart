part of 'game_card.dart';

class GameDateChip extends StatelessWidget {
  const GameDateChip({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 4,
      left: 4,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 6,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
          ),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ),
    );
  }
}
