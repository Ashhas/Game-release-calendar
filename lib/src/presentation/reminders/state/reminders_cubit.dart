import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:hive/hive.dart';

class RemindersCubit extends Cubit<RemindersState> {
  RemindersCubit({
    required Box<Game> remindersBox,
  })  : _remindersBox = remindersBox,
        super(RemindersState());

  final Box<Game> _remindersBox;

  List<Game> getGames() {
    List<Game> reminders = _remindersBox.values.toList();

    return reminders;
  }
}
