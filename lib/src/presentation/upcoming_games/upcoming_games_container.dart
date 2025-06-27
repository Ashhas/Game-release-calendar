import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/search_toolbar/search_toolbar.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_update_status_indicator.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

class UpcomingGamesContainer extends StatelessWidget {
  const UpcomingGamesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Icon(LucideIcons.calendar_search),
              SizedBox(width: context.spacings.m),
              const Text('Upcoming Games'),
            ],
          ),
          actions: [
            GameUpdateStatusIndicator(),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(context.spacings.xxxl),
            child: SearchToolbar(),
          ),
        ),
        body: BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
          builder: (context, state) {
            return state.games.when(
              data: (games) => games.isEmpty
                  ? AppEmptyWidget(
                      title: 'No Games Found',
                      message: state.nameQuery.isNotEmpty
                          ? 'Try adjusting your search or filters'
                          : 'No upcoming games available',
                      onAction: state.nameQuery.isNotEmpty
                          ? () => context.read<UpcomingGamesCubit>().clearSearch()
                          : null,
                      actionLabel: 'Clear Search',
                    )
                  : GameList(
                      games: games,
                    ),
              loading: () => const AppLoadingWidget(
                message: 'Loading games...',
              ),
              error: (error, _) => AppErrorWidget(
                error: error is Exception ? error : Exception(error.toString()),
                onRetry: () => context.read<UpcomingGamesCubit>().getGames(),
                title: 'Failed to Load Games',
              ),
            );
          },
        ),
      ),
    );
  }
}
