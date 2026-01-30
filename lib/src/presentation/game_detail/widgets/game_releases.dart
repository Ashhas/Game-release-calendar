part of '../game_detail_view.dart';

class ReminderActionButton extends StatelessWidget {
  const ReminderActionButton({
    super.key,
    required this.isChecked,
    required this.hasBeenReleased,
    required this.onPressed,
  });

  final bool isChecked;
  final bool hasBeenReleased;
  final VoidCallback onPressed;

  static const double _buttonWidth = 140.0;
  static const double _fontSize = 13.0;
  static const String _setReminderText = 'Set Reminder';
  static const String _removeReminderText = 'Remove';
  static const String _outOfDateText = 'Out of Date';

  ButtonStyle _getButtonStyle(BuildContext context, _ReminderButtonState state) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (state) {
      case _ReminderButtonState.setReminder:
        return FilledButton.styleFrom(
          textStyle: const TextStyle(fontSize: _fontSize),
        );
      case _ReminderButtonState.removeReminder:
        return FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.primary,
          textStyle: const TextStyle(fontSize: _fontSize),
        );
      case _ReminderButtonState.outOfDate:
        return FilledButton.styleFrom(
          textStyle: const TextStyle(fontSize: _fontSize),
        );
    }
  }

  _ReminderButtonState _getButtonState() {
    if (hasBeenReleased) return _ReminderButtonState.outOfDate;
    if (isChecked) return _ReminderButtonState.removeReminder;
    return _ReminderButtonState.setReminder;
  }

  String _getButtonText(_ReminderButtonState state) {
    switch (state) {
      case _ReminderButtonState.setReminder:
        return _setReminderText;
      case _ReminderButtonState.removeReminder:
        return _removeReminderText;
      case _ReminderButtonState.outOfDate:
        return _outOfDateText;
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonState = _getButtonState();

    return SizedBox(
      width: _buttonWidth,
      child: _ReminderButton(
        state: buttonState,
        onPressed: onPressed,
        getButtonStyle: _getButtonStyle,
        getButtonText: _getButtonText,
      ),
    );
  }
}

enum _ReminderButtonState {
  setReminder,
  removeReminder,
  outOfDate,
}

class _ReminderButton extends StatelessWidget {
  const _ReminderButton({
    required this.state,
    required this.onPressed,
    required this.getButtonStyle,
    required this.getButtonText,
  });

  final _ReminderButtonState state;
  final VoidCallback onPressed;
  final ButtonStyle Function(BuildContext context, _ReminderButtonState state) getButtonStyle;
  final String Function(_ReminderButtonState state) getButtonText;

  static const int _maxLines = 1;
  static const TextOverflow _textOverflow = TextOverflow.ellipsis;

  @override
  Widget build(BuildContext context) {
    if (state == _ReminderButtonState.outOfDate) {
      return FilledButton.tonal(
        style: getButtonStyle(context, state),
        onPressed: null,
        child: Text(
          getButtonText(state),
          maxLines: _maxLines,
          overflow: _textOverflow,
        ),
      );
    }

    return FilledButton(
      style: getButtonStyle(context, state),
      onPressed: onPressed,
      child: Text(
        getButtonText(state),
        maxLines: _maxLines,
        overflow: _textOverflow,
      ),
    );
  }
}

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
  late final GameDetailCubit _gameDetailCubit;
  late final List<ReleaseDate> _sortedReleaseDates;
  late final List<bool> _checkedStatus;

  @override
  void initState() {
    super.initState();
    // Sort release dates by date, then by platform name
    _sortedReleaseDates = _sortReleaseDates(widget.game.releaseDates);

    // Determine which platforms are already scheduled
    _gameDetailCubit = context.read<GameDetailCubit>();
    _checkedStatus = _sortedReleaseDates
        .map((rd) => _gameDetailCubit.isReminderSaved(
              rd.id,
            ))
        .toList();
  }

  List<ReleaseDate> _sortReleaseDates(List<ReleaseDate>? releaseDates) {
    if (releaseDates == null) return [];

    return releaseDates
        .sortedBy((rd) => ReleaseDateComparator.getSortableTimestamp(rd.date))
        .thenBy((rd) => rd.platform?.fullName ?? 'Unknown Platform')
        .thenBy((rd) => rd.region?.name ?? 'ZZ');
  }

  Future<void> _onReminderTileTapped(
    int index,
    ReleaseDate releaseDate,
  ) async {
    final isSaved = _gameDetailCubit.isReminderSaved(
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
    try {
      // Check battery optimization on first reminder
      await BatteryOptimizationDialog.showIfNeeded(context);

      await _gameDetailCubit.saveReminder(
        game: widget.game,
        releaseDate: releaseDate,
      );
      if (mounted) {
        _showToast(_reminderSavedMessage);
      }
    } catch (e) {
      debugPrint('Failed to save reminder: $e');
      if (mounted) {
        _showToast(_saveErrorMessage, isError: true);
      }
    }
  }

  Future<void> _removeReminder({
    required int releaseDateId,
  }) async {
    try {
      await _gameDetailCubit.removeReminder(releaseDateId: releaseDateId);
      if (mounted) {
        _showToast(_reminderRemovedMessage);
      }
    } catch (e) {
      debugPrint('Failed to remove reminder: $e');
      if (mounted) {
        _showToast(_removeErrorMessage, isError: true);
      }
    }
  }

  void _updateCheckedStatus(int index) {
    setState(() {
      _checkedStatus[index] = !_checkedStatus[index];
    });
  }

  static const Duration _toastDuration = Duration(seconds: 3);
  static const double _toastSpacing = 30.0;
  static const String _reminderSavedMessage = 'Reminder saved!';
  static const String _reminderRemovedMessage = 'Removed!';
  static const String _saveErrorMessage = 'Failed to save reminder. Please try again.';
  static const String _removeErrorMessage = 'Failed to remove reminder. Please try again.';

  void _showToast(String message, {bool isError = false}) {
    final colorScheme = Theme.of(context).colorScheme;

    ToastHelper.showToast(
      message,
      icon: isError ? Icons.error_outline : Icons.check_circle,
      backgroundColor: isError ? colorScheme.error : colorScheme.primary,
      textColor: isError ? colorScheme.onError : colorScheme.onPrimary,
      customSpacing: _toastSpacing,
      duration: _toastDuration,
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
          itemCount: _sortedReleaseDates.length,
          itemBuilder: (_, index) {
            final rd = _sortedReleaseDates[index];
            final platform = rd.platform;

            // Check if the release date has passed
            final date = rd.date;
            final hasBeenReleased = date != null &&
                DateUtilities.secondSinceEpochToDateTime(date)
                    .isBefore(DateTime.now());

            // Build subtitle with date/TBD and optional region
            String subtitle;
            if (date == null) {
              subtitle = 'TBD';
            } else {
              subtitle = rd.human ?? 'Release date available';
            }
            if (rd.region != null) {
              subtitle += ' • ${rd.region!.name}';
            }

            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0),
              enabled: !hasBeenReleased,
              title: Text(platform?.fullName ?? 'Unknown Platform'),
              subtitle: Text(subtitle),
              trailing: ReminderActionButton(
                isChecked: _checkedStatus[index],
                hasBeenReleased: hasBeenReleased,
                onPressed: () => _onReminderTileTapped(index, rd),
              ),
            );
          },
        ),
      ],
    );
  }
}
