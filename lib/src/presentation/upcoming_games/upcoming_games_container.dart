import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lucide/flutter_lucide.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/search_toolbar/search_toolbar.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_update_status_indicator.dart';
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
          builder: (_, state) {
            return state.games.when(
              data: (games) => games.isEmpty
                  ? Center(
                      child: Text(
                        'No games found',
                      ),
                    )
                  : GameList(
                      games: games,
                    ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, _) => Center(
                child: Text(
                  'Error: $error',
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
