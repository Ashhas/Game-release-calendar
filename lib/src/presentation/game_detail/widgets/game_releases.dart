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
  late final GameDetailCubit gameCubit;
  late final RemindersCubit remindersCubit;
  late final List<ReleaseDate> sortedReleaseDates;
  late final List<bool> checkedStatus;

  @override
  void initState() {
    super.initState();
    gameCubit = context.read<GameDetailCubit>();
    remindersCubit = context.read<RemindersCubit>();

    // Sort release dates by date, then by platform name
    sortedReleaseDates = _sortReleaseDates(widget.game.releaseDates);

    // Determine which platforms are already scheduled
    checkedStatus = sortedReleaseDates
        .map(
          (rd) => remindersCubit.isReleaseDateScheduled(
            gameId: widget.game.id,
            releaseDate: rd,
          ),
        )
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
    final gameId = widget.game.id;
    final isSaved = gameCubit.isGameSaved(gameId);

    if (!isSaved) {
      await _saveAndSchedule(
        gameId: gameId,
        releaseDate: releaseDate,
      );
      _updateCheckedStatus(index);
      return;
    }

    final isScheduled = remindersCubit.isReleaseDateScheduled(
      gameId: gameId,
      releaseDate: releaseDate,
    );

    if (isScheduled) {
      await _cancelReminderOrRemoveGame(
        gameId: gameId,
        releaseDate: releaseDate,
      );
      _updateCheckedStatus(index);
      return;
    }

    // If saved but not scheduled yet.
    await remindersCubit.scheduleNotification(
      game: widget.game,
      releaseDate: releaseDate,
    );
    _showSnackBar('Reminder scheduled!');
    _updateCheckedStatus(index);
  }

  Future<void> _saveAndSchedule({
    required int gameId,
    required ReleaseDate releaseDate,
  }) async {
    await gameCubit.saveGame(widget.game);
    await remindersCubit.scheduleNotification(
      game: widget.game,
      releaseDate: releaseDate,
    );
    _showSnackBar('Game saved & reminder scheduled!');
  }

  Future<void> _cancelReminderOrRemoveGame({
    required int gameId,
    required ReleaseDate releaseDate,
  }) async {
    await remindersCubit.cancelNotificationForPlatform(
      gameId: gameId,
      releaseDate: releaseDate,
    );

    if (!remindersCubit.hasScheduledNotifications(gameId)) {
      await gameCubit.removeGame(gameId);
      _showSnackBar('Reminder cancelled & game removed!');
    } else {
      _showSnackBar('Reminder cancelled!');
    }
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

            final convertedDate = DateTimeConverter.secondSinceEpochToDateTime(
              rd.date!,
            );
            final hasBeenReleased = convertedDate.isBefore(
              DateTime.now(),
            );
            final formattedDate = DateFormat('dd-MM-yyyy').format(
              convertedDate,
            );

            return CheckboxListTile(
              enabled: !hasBeenReleased,
              value: checkedStatus[index],
              title: Text(platform.fullName),
              subtitle: Text(formattedDate),
              onChanged: (_) => _onReminderTileTapped(index, rd),
            );
          },
        ),
      ],
    );
  }
}
