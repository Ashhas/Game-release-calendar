part of '../date_scrollbar.dart';

class _TooltipContent extends StatelessWidget {
  const _TooltipContent({required this.currentDate});

  final DateTime currentDate;

  @override
  Widget build(BuildContext context) {
    final onInverseSurface = Theme.of(context).colorScheme.onInverseSurface;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormat('MMM').format(currentDate),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: onInverseSurface,
            fontSize: 10,
          ),
        ),
        Text(
          DateFormat('d').format(currentDate),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: onInverseSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}