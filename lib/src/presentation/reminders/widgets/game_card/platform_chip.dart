part of 'game_card.dart';

class PlatformChip extends StatelessWidget {
  const PlatformChip({
    super.key,
    required this.platformAbbreviation,
  });

  final String platformAbbreviation;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.spacings.xxs),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(context.spacings.xxs)),
      ),
      child: Text(
        platformAbbreviation,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Colors.white,
            ),
      ),
    );
  }
}
