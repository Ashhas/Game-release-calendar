part of 'game_card.dart';

class DeleteChip extends StatelessWidget {
  const DeleteChip({
    super.key,
    required this.onRemove,
  });

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: context.spacings.xxs,
      right: context.spacings.xxs,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(context.spacings.xxs),
            bottomLeft: Radius.circular(context.spacings.xxs),
          ),
        ),
        child: SizedBox(
          width: context.spacings.xl,
          height: context.spacings.xl,
          child: IconButton(
            icon: Icon(
              Icons.delete_outline,
              size: context.spacings.l,
            ),
            onPressed: onRemove,
            padding: EdgeInsets.zero,
            tooltip: 'Remove reminder',
          ),
        ),
      ),
    );
  }
}
