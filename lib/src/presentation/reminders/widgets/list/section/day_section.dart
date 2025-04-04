part of '../reminder_list_view.dart';

class DaySection extends StatelessWidget {
  final MapEntry<DateTime, List<GameReminder>> groupedReminders;

  const DaySection({
    required this.groupedReminders,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _DayHeaderDelegate(
            date: groupedReminders.key,
            colorScheme: Theme.of(context).colorScheme,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => GameTile(
              reminder: groupedReminders.value[index],
            ),
            childCount: groupedReminders.value.length,
          ),
        ),
      ],
    );
  }
}

class _DayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;
  final ColorScheme colorScheme;

  const _DayHeaderDelegate({
    required this.date,
    required this.colorScheme,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final timeTillRelease = DateRangeUtility.getDayDifferenceLabel(
      date,
      currentDate: DateTime.now(),
    );

    return Container(
      color: colorScheme.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GameDateGrouper.tbdDate.isAtSameMomentAs(date)
                  ? const Text('TBD')
                  : Text(
                      DateFormat('EEEE, MMMM d y').format(date),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
            ],
          ),
          Text(
            timeTillRelease,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 60;

  @override
  double get minExtent => 60;

  @override
  bool shouldRebuild(covariant _DayHeaderDelegate oldDelegate) {
    return oldDelegate.date != date || oldDelegate.colorScheme != colorScheme;
  }
}
