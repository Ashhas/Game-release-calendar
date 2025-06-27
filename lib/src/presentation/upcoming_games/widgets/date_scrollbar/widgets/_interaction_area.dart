part of '../date_scrollbar.dart';

class _InteractionArea extends StatelessWidget {
  const _InteractionArea({
    required this.constraints,
    required this.onPanUpdate,
    required this.onPanStart,
    required this.onPanEnd,
  });

  final BoxConstraints constraints;
  final Function(DragUpdateDetails, BoxConstraints) onPanUpdate;
  final Function(DragStartDetails) onPanStart;
  final Function(DragEndDetails) onPanEnd;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) => onPanUpdate(details, constraints),
      onPanStart: onPanStart,
      onPanEnd: onPanEnd,
      child: Container(
        width: DateScrollbar.interactionWidth,
        height: constraints.maxHeight,
        color: Colors.transparent,
      ),
    );
  }
}
