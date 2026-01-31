part of 'game_card.dart';

class DeleteChip extends StatelessWidget {
  const DeleteChip({super.key, required this.onRemove});

  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(8),
        ),
      ),
      child: InkWell(
        onTap: onRemove,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(12),
          bottomLeft: Radius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(context.spacings.xs),
          child: Icon(
            Icons.notifications_off_outlined,
            size: context.spacings.l,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
