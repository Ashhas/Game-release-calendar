import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/data/igdb_service.dart';
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
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: IGDBService.instance.getOncomingGamesThisMonth(),
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
