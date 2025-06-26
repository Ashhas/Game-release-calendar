part of '../date_scrollbar.dart';

class _DateTooltip extends StatelessWidget {
  const _DateTooltip({
    required this.constraints,
    required this.isDragging,
    required this.dragPosition,
    required this.currentScrollPosition,
    required this.currentDate,
  });

  final BoxConstraints constraints;
  final bool isDragging;
  final double dragPosition;
  final double currentScrollPosition;
  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    final tooltipPosition = isDragging ? dragPosition : currentScrollPosition;
    
    return Positioned(
      right: DateScrollbar.tooltipOffset,
      top: (tooltipPosition * constraints.maxHeight) - 20,
      child: Material(
        elevation: 4,
        borderRadius: BorderRadius.circular(8),
        color: Theme.of(context).colorScheme.inverseSurface,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: _TooltipContent(currentDate: currentDate),
        ),
      ),
    );
  }
}