part of '../../upcoming_games_container.dart';

class ThisYearTab extends StatelessWidget {
  const ThisYearTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UpcomingGamesCubit, List<Game>>(
      builder: (context, state) {
        final groupedGames = FilterFunctions.filterAllGames(
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
