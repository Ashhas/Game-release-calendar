import 'package:game_release_calendar/src/domain/models/game.dart';

abstract class IGDBRepository {
  Future<List<Game>> getGames(String query);
}
