part of '../date_scrollbar.dart';

class _ScrollThumb extends StatelessWidget {
  const _ScrollThumb({
    required this.constraints,
    required this.isScrolling,
    required this.isDragging,
    required this.currentScrollPosition,
    required this.scrollController,
  });

  final BoxConstraints constraints;
  final bool isScrolling;
  final bool isDragging;
  final double currentScrollPosition;
  final ScrollController scrollController;

  @override
  Widget build(BuildContext context) {
    final thumbColor = (isScrolling || isDragging)
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.outline.withValues(alpha: 0.6);

    return Positioned(
      left: 1,
      top: _getScrollThumbPosition(),
      child: Container(
        width: DateScrollbar.thumbWidth,
        height: _getScrollThumbHeight(),
        decoration: BoxDecoration(
          color: thumbColor,
          borderRadius: BorderRadius.all(
            Radius.circular(DateScrollbar.thumbWidth / 2),
          ),
        ),
      ),
    );
  }

  double _getScrollThumbPosition() {
    if (!scrollController.hasClients) return 0.0;

    final thumbHeight = _getScrollThumbHeight();
    final maxPosition = constraints.maxHeight - thumbHeight;

    return (currentScrollPosition * maxPosition).clamp(0.0, maxPosition);
  }

  double _getScrollThumbHeight() {
    if (!scrollController.hasClients) return constraints.maxHeight * 0.1;

    final position = scrollController.position;
    final totalContent = position.maxScrollExtent + position.viewportDimension;
    final viewportRatio = position.viewportDimension / totalContent;

    const minThumbHeight = 20.0;
    return (constraints.maxHeight * viewportRatio).clamp(
      minThumbHeight,
      constraints.maxHeight,
    );
  }
}
