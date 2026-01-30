import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/lists/empty_list/empty_game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/lists/error_list/error_game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/lists/list/game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/lists/loading_list/loading_game_list.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/app_bar_header/app_bar_header.dart';

class UpcomingGamesContainer extends StatelessWidget {
  const UpcomingGamesContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: const AppBarHeader(),
        body: BlocBuilder<UpcomingGamesCubit, UpcomingGamesState>(
          builder: (context, state) {
            return state.games.when(
              data: (sections) => sections.isEmpty
                  ? EmptyGameList(
                      nameQuery: state.nameQuery,
                      onClearSearch: () =>
                          context.read<UpcomingGamesCubit>().clearSearch(),
                    )
                  : GameList(sections: sections),
              loading: () => const LoadingGameList(),
              error: (error, _) => ErrorGameList(
                error: error is Exception ? error : Exception(error.toString()),
                onRetry: () => context.read<UpcomingGamesCubit>().getGames(),
              ),
            );
          },
        ),
      ),
    );
  }
}
