part of 'game_card.dart';

class DeleteChip extends StatelessWidget {
  const DeleteChip({
    super.key,
    required this.onRemove,
  });

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(12),
        bottomLeft: Radius.circular(12),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          padding: EdgeInsets.all(context.spacings.xs),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.20),
          ),
          child: SizedBox(
            width: context.spacings.l,
            height: context.spacings.l,
            child: IconButton(
              icon: Icon(
                Icons.notifications_off_outlined,
                size: context.spacings.l,
                color: Colors.white,
              ),
              onPressed: onRemove,
              padding: EdgeInsets.zero,
              tooltip: 'Remove reminder',
            ),
          ),
        ),
      ),
    );
  }
}
