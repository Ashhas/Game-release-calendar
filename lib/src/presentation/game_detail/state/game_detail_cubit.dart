import 'dart:developer' as developer;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/presentation/common/state/notification_cubit/notifications_cubit.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_state.dart';
import '../../../domain/enums/release_date_category.dart';
import '../../../domain/models/notifications/game_reminder.dart';
import '../../../utils/date_time_converter.dart';

class GameDetailCubit extends Cubit<GameDetailState> {
  GameDetailCubit({
    required Box<GameReminder> remindersBox,
    required NotificationsCubit notificationsCubit,
  })  : _remindersBox = remindersBox,
        _notificationsCubit = notificationsCubit,
        super(GameDetailState());

  final Box<GameReminder> _remindersBox;
  final NotificationsCubit _notificationsCubit;

  List<GameReminder> get reminders => _remindersBox.values.toList();

  bool isReminderSaved(int reminderId) {
    return _remindersBox.containsKey(reminderId);
  }

  Future<void> saveReminder({
    required Game game,
    required ReleaseDate releaseDate,
  }) async {
    try {
      final notificationDate = DateTimeConverter.computeNotificationDate(
        releaseDate.date ?? 0,
      );
      final reminder = GameReminder.fromGame(
        game: game,
        releaseDate: releaseDate,
        releaseDateCategory:
            releaseDate.category ?? ReleaseDateCategory.exactDate,
        notificationDate: notificationDate,
      );

      await _remindersBox.put(releaseDate.id, reminder);
      await _notificationsCubit.scheduleNotificationFromReminder(
        gameReminder: reminder,
      );
      
      developer.log('Reminder saved successfully for game: ${game.name}');
    } catch (e, stackTrace) {
      developer.log('Error saving reminder: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  Future<void> removeReminder({
    required int releaseDateId,
  }) async {
    try {
      await _remindersBox.delete(releaseDateId);
      await _notificationsCubit.cancelNotification(
        releaseDateId,
      );
      
      developer.log('Reminder removed successfully for releaseId: $releaseDateId');
    } catch (e, stackTrace) {
      developer.log('Error removing reminder: $e', stackTrace: stackTrace);
      rethrow;
    }
  }
}
