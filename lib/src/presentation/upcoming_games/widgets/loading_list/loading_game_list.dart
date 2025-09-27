import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';

/// Widget displayed while games are loading
class LoadingGameList extends StatelessWidget {
  const LoadingGameList({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppLoadingWidget(
      message: 'Loading games...',
    );
  }
}