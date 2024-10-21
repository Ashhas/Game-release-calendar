part of '../game_list.dart';

class DaySection extends StatelessWidget {
  final MapEntry<DateTime, List<Game>> groupedGames;

  const DaySection({
    required this.groupedGames,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(date: groupedGames.key),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: groupedGames.value.length,
          itemBuilder: (_, index) => GameTile(game: groupedGames.value[index]),
        ),
      ],
    );
  }
}
