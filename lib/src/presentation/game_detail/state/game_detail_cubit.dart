import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/data/services/notification_service.dart';
import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/presentation/game_detail/state/game_detail_state.dart';

class GameDetailCubit extends Cubit<GameDetailState> {
  GameDetailCubit({
    required Box<Game> remindersBox,
    required NotificationClient notificationClient,
  })  : _remindersBox = remindersBox,
        _notificationClient = notificationClient,
        super(GameDetailState());

  final Box<Game> _remindersBox;
  final NotificationClient _notificationClient;

  void saveGame(Game game) {
    _remindersBox.put(game.id, game);
  }

  void scheduleNotification(Game game) {
    _notificationClient.scheduleNotification(game);
  }
}
