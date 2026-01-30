part of '../game_list.dart';

class _GameListScrollView extends StatelessWidget {
  const _GameListScrollView({
    required this.sections,
    required this.scrollController,
    required this.sectionKeys,
    required this.isLoading,
    required this.isScrollbarEnabled,
  });

  final List<GameSection> sections;
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final bool isLoading;
  final bool isScrollbarEnabled;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: scrollController,
      slivers: [
        if (sections.isEmpty)
          const SliverFillRemaining(
            child: Center(child: Text('No games found')),
          )
        else
          ...sections.map((section) {
            return DaySection(
              section: section,
              key: sectionKeys[section.key] ?? ValueKey(section.key),
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
