import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/igdb_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class UpcomingGamesCubit extends Cubit<List<Game>> {
  UpcomingGamesCubit({
    required IGDBService igdbService,
  })  : _igdbService = igdbService,
        super([]);

  final IGDBService _igdbService;

  void getGames() async {
    final games = await _igdbService.getGamesThisAndNextTwoMonths();
    emit(games);
  }
}
