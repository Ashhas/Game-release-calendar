import 'package:game_release_calendar/src/domain/models/game.dart';

abstract class IGDBRepository {
  Future<List<Game>> getOncomingGamesThisMonth();
  Future<List<Game>> getGamesThisMonth();
  Future<List<Game>> getGamesNextMonth();
  Future<List<Game>> getGamesThisAndNextTwoMonths();
}