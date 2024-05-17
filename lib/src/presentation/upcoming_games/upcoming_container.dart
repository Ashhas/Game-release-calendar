import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/section/day_section.dart';
import 'package:game_release_calendar/src/utils/filter_functions.dart';

class UpcomingGamesContainer extends StatefulWidget {
  const UpcomingGamesContainer({
    super.key,
  });

  @override
  State<UpcomingGamesContainer> createState() => _UpcomingGamesContainerState();
}

class _UpcomingGamesContainerState extends State<UpcomingGamesContainer> {
  @override
  void initState() {
    context.read<UpcomingGamesCubit>().getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingGamesCubit, List<Game>>(
      builder: (context, state) {
        final groupedGames = FilterFunctions.groupGamesByDay(
          state,
        );

        return ListView.builder(
          itemCount: groupedGames.length,
          itemBuilder: (_, int index) {
            final dayWithList = groupedGames.entries.elementAt(index);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DaySection(
                  groupedGames: dayWithList,
                ),
                const Divider(
                  thickness: 1,
                ),
              ],
            );
          },
        );
      },
    );
  }
}
