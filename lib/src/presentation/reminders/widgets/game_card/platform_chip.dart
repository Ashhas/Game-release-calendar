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
      top: context.spacings.xxs,
      left: context.spacings.xxs,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: context.spacings.xxs,
          vertical: context.spacings.xxs,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.spacings.xxs),
            bottomRight: Radius.circular(context.spacings.xxs),
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
