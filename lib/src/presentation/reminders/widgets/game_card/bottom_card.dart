part of 'game_card.dart';

class BottomCard extends StatelessWidget {
  const BottomCard({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(context.spacings.s, context.spacings.xxs, context.spacings.s, context.spacings.s),
      child: Text(
        description,
        style: Theme.of(context).textTheme.labelMedium,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }
}
