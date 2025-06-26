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
      top: 4,
      right: 4,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(6),
            bottomLeft: Radius.circular(6),
          ),
        ),
        child: SizedBox(
          width: 25,
          height: 25,
          child: IconButton(
            icon: const Icon(
              Icons.delete_outline,
              size: 20,
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
