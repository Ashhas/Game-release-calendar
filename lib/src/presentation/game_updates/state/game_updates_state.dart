import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/game_update_log.dart';

class GameUpdatesState {
  const GameUpdatesState({
    this.updateLogs = const AsyncValue.loading(),
  });

  final AsyncValue<List<GameUpdateLog>> updateLogs;

  GameUpdatesState copyWith({
    AsyncValue<List<GameUpdateLog>>? updateLogs,
  }) {
    return GameUpdatesState(
      updateLogs: updateLogs ?? this.updateLogs,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameUpdatesState && other.updateLogs == updateLogs;
  }

  @override
  int get hashCode => updateLogs.hashCode;

  @override
  String toString() {
    return 'GameUpdatesState(updateLogs: $updateLogs)';
  }
}