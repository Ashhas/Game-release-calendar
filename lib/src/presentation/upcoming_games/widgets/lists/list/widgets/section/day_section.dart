part of '../../game_list.dart';

class DaySection extends StatelessWidget {
  final GameSection section;

  const DaySection({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return SliverMainAxisGroup(
      slivers: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _DayHeaderDelegate(
            section: section,
            colorScheme: Theme.of(context).colorScheme,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (_, index) =>
                GameTile(game: section.games[index], isTbd: section.isTbd),
            childCount: section.games.length,
          ),
        ),
      ],
    );
  }
}

class _DayHeaderDelegate extends SliverPersistentHeaderDelegate {
  final GameSection section;
  final ColorScheme colorScheme;

  const _DayHeaderDelegate({required this.section, required this.colorScheme});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final isTbdSection = section.isTbd;
    final isCompleteTbd = section.precision == DatePrecision.tbd;

    // For exact dates, show time until release
    String? timeTillRelease;
    if (!isTbdSection && !isCompleteTbd) {
      timeTillRelease = DateRangeUtility.getDayDifferenceLabel(
        section.date,
        currentDate: DateTime.now(),
      );
    }

    return Container(
      color: colorScheme.surface,
      padding: EdgeInsets.symmetric(
        horizontal: context.spacings.m,
        vertical: context.spacings.xs,
      ),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            _getHeaderText(),
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontStyle: isTbdSection ? FontStyle.italic : null,
            ),
          ),
          if (timeTillRelease != null)
            Text(timeTillRelease, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }

  String _getHeaderText() {
    switch (section.precision) {
      case DatePrecision.exactDay:
        if (GameDateGrouper.tbdDate.isAtSameDayAs(section.date)) {
          return 'TBD';
        }
        return DateFormat('EEEE, MMMM d y').format(section.date);
      case DatePrecision.month:
      case DatePrecision.quarter:
      case DatePrecision.year:
      case DatePrecision.tbd:
        return section.headerText;
    }
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant _DayHeaderDelegate oldDelegate) {
    return oldDelegate.section != section ||
        oldDelegate.colorScheme != colorScheme;
  }
}
