part of '../date_scrollbar.dart';

class _ScrollTrack extends StatelessWidget {
  const _ScrollTrack();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: DateScrollbar.scrollbarWidth,
      margin: EdgeInsets.only(
        left: (DateScrollbar.thumbWidth - DateScrollbar.scrollbarWidth) / 2,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(DateScrollbar.scrollbarWidth / 2),
      ),
    );
  }
}
