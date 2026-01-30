import 'dart:developer' as dev;

import 'package:flutter/material.dart';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:spaced_flex/spaced_flex.dart';

import 'package:game_release_calendar/src/data/services/analytics_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/battery_optimization_dialog.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_image.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import '../../utils/constants.dart';
import '../../utils/release_date_comparator.dart';
import '../common/toast/toast_helper.dart';

part 'widgets/game_info.dart';

part 'widgets/game_releases.dart';

class GameDetailView extends StatefulWidget {
  const GameDetailView({
    required this.game,
    super.key,
  });

  final Game game;

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  @override
  void initState() {
    super.initState();

    // Track screen and game view
    final analytics = GetIt.instance.get<AnalyticsService>();
    analytics.trackScreenViewed(
      screenName: 'GameDetail',
      properties: {'game_name': widget.game.name},
    );
    analytics.trackGameViewed(
      gameId: widget.game.id,
      gameName: widget.game.name,
    );
  }

  @override
  Widget build(BuildContext context) {
    dev.log(widget.game.toString());
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: context.spacings.m),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GameInfo(game: widget.game),
              GameReleases(game: widget.game),
            ],
          ),
        ),
      ),
    );
  }
}
