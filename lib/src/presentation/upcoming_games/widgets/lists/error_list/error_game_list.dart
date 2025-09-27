import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';

/// Widget displayed when there's an error loading games
class ErrorGameList extends StatelessWidget {
  const ErrorGameList({
    super.key,
    required this.error,
    this.onRetry,
  });

  final Exception error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return AppErrorWidget(
      error: error,
      onRetry: onRetry,
      title: 'Failed to Load Games',
    );
  }
}