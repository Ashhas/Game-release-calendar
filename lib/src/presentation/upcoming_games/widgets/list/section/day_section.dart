part of '../game_list.dart';

class DaySection extends StatelessWidget {
  final MapEntry<DateTime, List<Game>> groupedGames;

  const DaySection({
    required this.groupedGames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _DayHeaderDelegate(date: groupedGames.key),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) => GameTile(
              game: groupedGames.value[index],
            ),
            childCount: groupedGames.value.length,
          ),
        ),
      ],
    );
  }
}

class _DayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final DateTime date;

  const _DayHeaderDelegate({required this.date});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final timeTillRelease = DateRangeUtility.getDayDifferenceLabel(
      date,
      currentDate: DateTime.now(),
    );

    return Container(
      color: Theme.of(context).colorScheme.surface,
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
              Text(
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
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
