import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/home/state/home_cubit.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/section/day_section.dart';
import 'package:game_release_calendar/src/utils/filter_functions.dart';

class OncomingMonthTab extends StatefulWidget {
  const OncomingMonthTab({
    super.key,
  });

  @override
  State<OncomingMonthTab> createState() => _OncomingMonthTabState();
}

class _OncomingMonthTabState extends State<OncomingMonthTab> {
  @override
  void initState() {
    context.read<HomeCubit>().getGames();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, List<Game>>(
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
