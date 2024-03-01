import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/data/igdb_service.dart';
import 'package:game_release_calendar/src/presentation/home/widgets/section/day_section.dart';
import 'package:game_release_calendar/src/utils/filter_functions.dart';

class NextMonthTab extends StatefulWidget {
  const NextMonthTab({
    super.key,
  });

  @override
  State<NextMonthTab> createState() => _NextMonthTabState();
}

class _NextMonthTabState extends State<NextMonthTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getGamesNextMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final groupedGames = FilterFunctions.groupGamesByDay(
            snapshot.data!,
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
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
