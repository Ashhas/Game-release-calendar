import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_update_state.freezed.dart';

@freezed
class GameUpdateState with _$GameUpdateState {
  const factory GameUpdateState.idle() = _Idle;
  const factory GameUpdateState.loading({
    required int totalGames,
    required int processedGames,
  }) = _Loading;
  const factory GameUpdateState.completed() = _Completed;
  const factory GameUpdateState.error(String message) = _Error;
}