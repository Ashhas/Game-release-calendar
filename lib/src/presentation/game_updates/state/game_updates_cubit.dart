import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/enums/game_update_type.dart';
import 'game_updates_state.dart';

class GameUpdatesCubit extends Cubit<GameUpdatesState> {
  GameUpdatesCubit({
    required Box<GameUpdateLog> gameUpdateLogBox,
  })  : _gameUpdateLogBox = gameUpdateLogBox,
        super(const GameUpdatesState());

  final Box<GameUpdateLog> _gameUpdateLogBox;

  /// Load recent update logs (last 50 entries)
  Future<void> loadRecentUpdateLogs() async {
    try {
      emit(state.copyWith(updateLogs: const AsyncValue.loading()));

      final allLogs = _gameUpdateLogBox.values.toList();

      // Sort by detection date (newest first)
      allLogs.sort((a, b) => b.detectedAt.compareTo(a.detectedAt));

      // Take last 50 entries
      final recentLogs = allLogs.take(50).toList();

      emit(state.copyWith(
        updateLogs: AsyncValue.data(recentLogs),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(
        updateLogs: AsyncValue.error(e, stackTrace),
      ));
    }
  }

  /// Filter update logs by date range
  Future<void> filterLogsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      emit(state.copyWith(updateLogs: const AsyncValue.loading()));

      final allLogs = _gameUpdateLogBox.values.where((log) {
        return log.detectedAt.isAfter(startDate) &&
               log.detectedAt.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();

      // Sort by detection date (newest first)
      allLogs.sort((a, b) => b.detectedAt.compareTo(a.detectedAt));

      emit(state.copyWith(
        updateLogs: AsyncValue.data(allLogs),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(
        updateLogs: AsyncValue.error(e, stackTrace),
      ));
    }
  }

  /// Filter update logs by update type
  Future<void> filterLogsByType(GameUpdateType updateType) async {
    try {
      emit(state.copyWith(updateLogs: const AsyncValue.loading()));

      final filteredLogs = _gameUpdateLogBox.values
          .where((log) => log.updateType == updateType)
          .toList();

      // Sort by detection date (newest first)
      filteredLogs.sort((a, b) => b.detectedAt.compareTo(a.detectedAt));

      emit(state.copyWith(
        updateLogs: AsyncValue.data(filteredLogs),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(
        updateLogs: AsyncValue.error(e, stackTrace),
      ));
    }
  }

  /// Get update logs for a specific game
  Future<void> filterLogsByGame(int gameId) async {
    try {
      emit(state.copyWith(updateLogs: const AsyncValue.loading()));

      final gameLogs = _gameUpdateLogBox.values
          .where((log) => log.gameId == gameId)
          .toList();

      // Sort by detection date (newest first)
      gameLogs.sort((a, b) => b.detectedAt.compareTo(a.detectedAt));

      emit(state.copyWith(
        updateLogs: AsyncValue.data(gameLogs),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(
        updateLogs: AsyncValue.error(e, stackTrace),
      ));
    }
  }

  /// Get logs from today
  Future<void> getTodaysLogs() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    await filterLogsByDateRange(
      startDate: today,
      endDate: tomorrow,
    );
  }

  /// Get logs from last week
  Future<void> getLastWeekLogs() async {
    final now = DateTime.now();
    final weekAgo = now.subtract(const Duration(days: 7));

    await filterLogsByDateRange(
      startDate: weekAgo,
      endDate: now,
    );
  }

  /// Clear all logs (for debugging/testing)
  Future<void> clearAllLogs() async {
    try {
      await _gameUpdateLogBox.clear();
      emit(state.copyWith(
        updateLogs: const AsyncValue.data([]),
      ));
    } catch (e, stackTrace) {
      emit(state.copyWith(
        updateLogs: AsyncValue.error(e, stackTrace),
      ));
    }
  }

  /// Get total number of logs
  int get totalLogsCount => _gameUpdateLogBox.length;

  /// Check if there are any logs
  bool get hasLogs => _gameUpdateLogBox.isNotEmpty;
}