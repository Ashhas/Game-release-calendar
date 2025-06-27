part of '../date_scrollbar.dart';

class _ScrollbarStack extends StatelessWidget {
  const _ScrollbarStack({
    required this.constraints,
    required this.isScrolling,
    required this.isDragging,
    required this.dragPosition,
    required this.currentScrollPosition,
    required this.currentDate,
    required this.scrollController,
    required this.onPanUpdate,
    required this.onPanStart,
    required this.onPanEnd,
  });

  final BoxConstraints constraints;
  final bool isScrolling;
  final bool isDragging;
  final double dragPosition;
  final double currentScrollPosition;
  final DateTime? currentDate;
  final ScrollController scrollController;
  final Function(DragUpdateDetails, BoxConstraints) onPanUpdate;
  final Function(DragStartDetails) onPanStart;
  final Function(DragEndDetails) onPanEnd;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _ScrollTrack(),
        if (scrollController.hasClients)
          _ScrollThumb(
            constraints: constraints,
            isScrolling: isScrolling,
            isDragging: isDragging,
            currentScrollPosition: currentScrollPosition,
            scrollController: scrollController,
          ),
        if ((isScrolling || isDragging) && currentDate != null)
          _DateTooltip(
            constraints: constraints,
            isDragging: isDragging,
            dragPosition: dragPosition,
            currentScrollPosition: currentScrollPosition,
            currentDate: currentDate!,
          ),
        _InteractionArea(
          constraints: constraints,
          onPanUpdate: onPanUpdate,
          onPanStart: onPanStart,
          onPanEnd: onPanEnd,
        ),
      ],
    );
  }
}
