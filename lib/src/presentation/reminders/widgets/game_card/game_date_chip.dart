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
      bottom: context.spacings.xxs,
      left: context.spacings.xxs,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacings.xxs,
          vertical: context.spacings.xxs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(context.spacings.xxs),
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
