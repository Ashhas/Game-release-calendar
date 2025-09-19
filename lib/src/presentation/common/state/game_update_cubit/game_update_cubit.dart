import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/game_update_service.dart';
import 'package:game_release_calendar/src/presentation/common/state/game_update_cubit/game_update_state.dart';

class GameUpdateCubit extends Cubit<GameUpdateState> {
  final GameUpdateService gameUpdateService;

  GameUpdateCubit({
    required this.gameUpdateService,
  }) : super(const GameUpdateState.idle());

  Future<void> startBackgroundUpdate() async {
    if (state.maybeWhen(
      loading: (_, __) => true,
      orElse: () => false,
    )) return;

    try {
      emit(const GameUpdateState.loading(totalGames: 0, processedGames: 0));

      // Run the update with progress callbacks
      final hasUpdates =
          await gameUpdateService.checkAndUpdateBookmarkedGamesWithProgress(
        onProgress: (total, processed) {
          emit(GameUpdateState.loading(
            totalGames: total,
            processedGames: processed,
          ));
        },
      );

      emit(hasUpdates
          ? const GameUpdateState.updated()
          : const GameUpdateState.completed());

      // Reset to idle after a short delay
      Timer(const Duration(seconds: 2), () {
        state.whenOrNull(
          completed: () => emit(const GameUpdateState.idle()),
          updated: () => emit(const GameUpdateState.idle()),
        );
      });
    } catch (e) {
      dev.log('Error during background update: $e');
      emit(GameUpdateState.error(e.toString()));

      // Reset to idle after showing error
      Timer(const Duration(seconds: 3), () {
        state.whenOrNull(
          error: (_) => emit(const GameUpdateState.idle()),
        );
      });
    }
  }
}
