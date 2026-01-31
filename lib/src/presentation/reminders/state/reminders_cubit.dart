import 'dart:async';

import 'package:dartx/dartx.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_ce/hive.dart';
import 'package:riverpod/riverpod.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/utils/release_date_comparator.dart';
import '../../../data/services/shared_prefs_service.dart';
import '../../common/state/notification_cubit/notifications_cubit.dart';
import '../../common/state/notification_cubit/notifications_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required NotificationsCubit notificationsCubit,
    required Box<GameReminder> remindersBox,
    required SharedPrefsService prefsService,
  }) : _remindersBox = remindersBox,
       _notificationsCubit = notificationsCubit,
       _prefsService = prefsService,
       super(RemindersState()) {
    _notificationsSubscription = _notificationsCubit.stream.listen((state) {
      state.notifications.whenData((_) {
        loadGames();
      });
    });
  }

  final Box<GameReminder> _remindersBox;
  final NotificationsCubit _notificationsCubit;
  final SharedPrefsService _prefsService;
  StreamSubscription<NotificationsState>? _notificationsSubscription;

  @override
  Future<void> close() {
    _notificationsSubscription?.cancel();
    return super.close();
  }

  final prefDataViewKey = 'preferred_data_view_index';

  Future<void> loadGames() async {
    final reminders = _remindersBox.values.toList();
    final sortedReminders = _sortReminders(reminders);
    emit(state.copyWith(reminders: sortedReminders));
  }

  List<GameReminder> _sortReminders(List<GameReminder> reminders) {
    return reminders
        .sortedBy(
          (reminder) => ReleaseDateComparator.getSortableTimestamp(
            reminder.releaseDate.date,
          ),
        )
        .thenBy(
          (reminder) => reminder.releaseDate.hasExactDate ? 0 : 1,
        ) // Exact dates first
        .thenBy((reminder) => reminder.gameName);
  }

  Future<void> removeReminder(int reminderId) async {
    _remindersBox.delete(reminderId);
    loadGames();
  }

  Future<void> storePreferredDataView(int viewIndex) async {
    _prefsService.setInt('prefDataViewKey', viewIndex);
    emit(state.copyWith(reminderViewIndex: viewIndex));
  }

  Future<void> getPreferredDataView() async {
    final viewIndex = await _prefsService.getInt('prefDataViewKey') ?? 0;
    emit(state.copyWith(reminderViewIndex: viewIndex));
  }
}
