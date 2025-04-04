part of '../game_detail_view.dart';

class GameReleases extends StatefulWidget {
  const GameReleases({
    super.key,
    required this.game,
  });

  final Game game;

  @override
  State<GameReleases> createState() => _GameReleasesState();
}

class _GameReleasesState extends State<GameReleases> {
  late final GameDetailCubit gameDetailCubit;
  late final List<ReleaseDate> sortedReleaseDates;
  late final List<bool> checkedStatus;

  @override
  void initState() {
    super.initState();
    // Sort release dates by date, then by platform name
    sortedReleaseDates = _sortReleaseDates(widget.game.releaseDates);

    // Determine which platforms are already scheduled
    gameDetailCubit = context.read<GameDetailCubit>();
    checkedStatus = sortedReleaseDates
        .map((rd) => gameDetailCubit.isReminderSaved(
              rd.id,
            ))
        .toList();
  }

  List<ReleaseDate> _sortReleaseDates(List<ReleaseDate>? releaseDates) {
    if (releaseDates == null) return [];

    return releaseDates
        .sortedBy((rd) => rd.date ?? 0)
        .thenBy((rd) => rd.platform!.fullName);
  }

  Future<void> _onReminderTileTapped(
    int index,
    ReleaseDate releaseDate,
  ) async {
    final isSaved = gameDetailCubit.isReminderSaved(
      releaseDate.id,
    );

    if (!isSaved) {
      await _saveReminder(
        releaseDate: releaseDate,
      );
      _updateCheckedStatus(index);
      return;
    } else {
      await _removeReminder(
        releaseDateId: releaseDate.id,
      );
      _updateCheckedStatus(index);
      return;
    }
  }

  Future<void> _saveReminder({
    required ReleaseDate releaseDate,
  }) async {
    await gameDetailCubit.saveReminder(
      game: widget.game,
      releaseDate: releaseDate,
    );
    _showSnackBar('Reminder saved!');
  }

  Future<void> _removeReminder({
    required int releaseDateId,
  }) async {
    await gameDetailCubit.removeReminder(releaseDateId: releaseDateId);
    _showSnackBar('Reminder cancelled!');
  }

  void _updateCheckedStatus(int index) {
    setState(() {
      checkedStatus[index] = !checkedStatus[index];
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Releases Reminders', style: TextStyle(fontSize: 20)),
        SizedBox(height: context.spacings.xs),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: sortedReleaseDates.length,
          itemBuilder: (_, index) {
            final rd = sortedReleaseDates[index];
            final platform = rd.platform!;

            // If date is null, mark as "TBD" and disable
            final date = rd.date;
            if (date == null) {
              return CheckboxListTile(
                enabled: false,
                value: checkedStatus[index],
                title: Text(platform.fullName),
                subtitle: const Text('TBD'),
                onChanged: null,
              );
            }

            final hasBeenReleased =
                DateTimeConverter.secondSinceEpochToDateTime(rd.date!)
                    .isBefore(DateTime.now());

            return CheckboxListTile(
              enabled: !hasBeenReleased,
              value: checkedStatus[index],
              title: Text(platform.fullName),
              subtitle: Text(rd.human.toString()),
              onChanged: (_) => _onReminderTileTapped(index, rd),
            );
          },
        ),
      ],
    );
  }
}
