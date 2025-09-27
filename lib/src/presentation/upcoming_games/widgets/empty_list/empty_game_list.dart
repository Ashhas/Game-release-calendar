import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';

/// Widget displayed when the games list is empty
/// Handles both search and no-search empty states
class EmptyGameList extends StatelessWidget {
  const EmptyGameList({
    super.key,
    required this.nameQuery,
    this.onClearSearch,
  });

  final String nameQuery;
  final VoidCallback? onClearSearch;

  @override
  Widget build(BuildContext context) {
    final hasSearch = nameQuery.isNotEmpty;

    return AppEmptyWidget(
      title: 'No Games Found',
      message: hasSearch
          ? 'Try adjusting your search or filters'
          : 'No upcoming games available',
      onAction: hasSearch ? onClearSearch : null,
      actionLabel: hasSearch ? 'Clear Search' : null,
    );
  }
}