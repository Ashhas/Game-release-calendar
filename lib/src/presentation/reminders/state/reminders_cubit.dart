import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required Box<GameReminder> remindersBox,
  })  : _remindersBox = remindersBox,
        super(RemindersState());

  final Box<GameReminder> _remindersBox;

  Future<void> loadGames() async {
    final reminders = _remindersBox.values.toList();
    emit(state.copyWith(reminders: reminders));
  }

  Future<void> removeReminder(int reminderId) async {
    _remindersBox.delete(reminderId);
    loadGames();
  }
}
