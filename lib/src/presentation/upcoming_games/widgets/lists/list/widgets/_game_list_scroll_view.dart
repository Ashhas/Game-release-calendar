part of '../game_list.dart';

class _GameListScrollView extends StatelessWidget {
  const _GameListScrollView({
    required this.entries,
    required this.scrollController,
    required this.sectionKeys,
    required this.isLoading,
    required this.isScrollbarEnabled,
  });

  final List<MapEntry<DateTime, List<Game>>> entries;
  final ScrollController scrollController;
  final Map<DateTime, GlobalKey> sectionKeys;
  final bool isLoading;
  final bool isScrollbarEnabled;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      physics: isScrollbarEnabled
          ? SnapScrollPhysics(
              sectionKeys: sectionKeys,
              scrollController: scrollController,
            )
          : null,
      slivers: [
        if (entries.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No games found')),
          )
        else
          ...entries.map((entry) {
            return DaySection(
              groupedGames: entry,
              key: sectionKeys[entry.key] ?? ValueKey(entry.key),
            );
          }),
        if (isLoading)
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
      ],
    );
  }
}
