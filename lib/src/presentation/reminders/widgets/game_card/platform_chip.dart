part of 'game_card.dart';

class PlatformChip extends StatelessWidget {
  const PlatformChip({
    super.key,
    required this.platformAbbreviation,
  });

  final String platformAbbreviation;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(6)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: EdgeInsets.all(context.spacings.xxs),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.24),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.spacings.xxs),
              bottomRight: Radius.circular(context.spacings.xxs),
            ),
          ),
          child: Text(
            platformAbbreviation,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
          ),
        ),
      ),
    );
  }
}
