import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/domain/models/game_update_log.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/utils/date_utilities.dart';
import 'game_updates_badge_state.dart';

class GameUpdatesBadgeCubit extends Cubit<GameUpdatesBadgeState> {
  GameUpdatesBadgeCubit({
    required Box<GameReminder> remindersBox,
    required Box<GameUpdateLog> gameUpdateLogBox,
    required SharedPrefsService prefsService,
  }) : _remindersBox = remindersBox,
       _gameUpdateLogBox = gameUpdateLogBox,
       _prefsService = prefsService,
       super(const GameUpdatesBadgeState());

  final Box<GameReminder> _remindersBox;
  final Box<GameUpdateLog> _gameUpdateLogBox;
  final SharedPrefsService _prefsService;

  static const String _lastReadDateKey = 'game_updates_last_read_date';

  // Track counts when badge was last read this session
  int _releasesCountWhenRead = 0;
  int _updateLogsCountWhenRead = 0;

  /// Check if badge should be shown based on today's releases and new logs
  Future<void> checkBadgeStatus() async {
    try {
      // Load last read date from preferences
      final lastReadTimestamp = await _prefsService.getInt(_lastReadDateKey);
      final lastReadDate = lastReadTimestamp != null
          ? DateTime.fromMillisecondsSinceEpoch(lastReadTimestamp)
          : null;

      // Count today's releases
      final todayReleasesCount = _getTodayReleasesCount();

      // Count today's update logs
      final todayUpdateLogsCount = _getTodayUpdateLogsCount();

      // Determine if badge should show
      final hasContent = todayReleasesCount > 0 || todayUpdateLogsCount > 0;
      final isReadToday = _isReadToday(lastReadDate);

      // Check if there are new items since last read this session
      final hasNewItemsSinceRead =
          todayReleasesCount > _releasesCountWhenRead ||
          todayUpdateLogsCount > _updateLogsCountWhenRead;

      // Show badge if:
      // 1. Has content AND not read today (first time today)
      // 2. OR has content AND read today BUT new items appeared this session
      final shouldShowBadge =
          hasContent && (!isReadToday || hasNewItemsSinceRead);

      emit(
        GameUpdatesBadgeState(
          shouldShowBadge: shouldShowBadge,
          lastReadDate: lastReadDate,
          todayReleasesCount: todayReleasesCount,
          todayUpdateLogsCount: todayUpdateLogsCount,
        ),
      );
    } catch (e) {
      // If there's an error, don't show badge to be safe
      emit(const GameUpdatesBadgeState());
    }
  }

  /// Mark the game updates page as read for today
  Future<void> markAsReadToday() async {
    try {
      final now = DateTime.now();
      await _prefsService.setInt(_lastReadDateKey, now.millisecondsSinceEpoch);

      // Store current counts for this session
      _releasesCountWhenRead = _getTodayReleasesCount();
      _updateLogsCountWhenRead = _getTodayUpdateLogsCount();

      emit(state.copyWith(lastReadDate: now, shouldShowBadge: false));
    } catch (e) {
      // If saving fails, at least hide the badge in the UI and store counts
      _releasesCountWhenRead = _getTodayReleasesCount();
      _updateLogsCountWhenRead = _getTodayUpdateLogsCount();
      emit(state.copyWith(shouldShowBadge: false));
    }
  }

  /// Get count of games releasing today
  int _getTodayReleasesCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _remindersBox.values.where((reminder) {
      final releaseDate = reminder.releaseDate.date;
      if (releaseDate == null) return false;

      // Only count games with exact release dates, not vague dates like Q4 or "March 2024"
      if (!reminder.releaseDate.hasExactDate) return false;

      final releaseDateTime = DateUtilities.secondSinceEpochToDateTime(
        releaseDate,
      );
      final releaseDateOnly = DateTime(
        releaseDateTime.year,
        releaseDateTime.month,
        releaseDateTime.day,
      );

      return releaseDateOnly.isAtSameMomentAs(today);
    }).length;
  }

  /// Get count of update logs from today
  int _getTodayUpdateLogsCount() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _gameUpdateLogBox.values.where((log) {
      final logDate = DateTime(
        log.detectedAt.year,
        log.detectedAt.month,
        log.detectedAt.day,
      );

      return logDate.isAtSameMomentAs(today);
    }).length;
  }

  /// Check if the updates page was read today
  bool _isReadToday(DateTime? lastReadDate) {
    if (lastReadDate == null) return false;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final readDate = DateTime(
      lastReadDate.year,
      lastReadDate.month,
      lastReadDate.day,
    );

    return readDate.isAtSameMomentAs(today) || readDate.isAfter(today);
  }

  /// Force refresh the badge status (useful for when data changes)
  void refreshBadgeStatus() {
    checkBadgeStatus();
  }

  /// Reset session tracking (useful for testing or when data is refreshed)
  void resetSessionTracking() {
    _releasesCountWhenRead = 0;
    _updateLogsCountWhenRead = 0;
    checkBadgeStatus();
  }
}
