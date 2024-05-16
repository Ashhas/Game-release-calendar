import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class IGDBService {
  final IGDBRepository repository;

  IGDBService({
    required this.repository,
  });

  Future<List<Game>> getOncomingGamesThisMonth() {
    return repository.getOncomingGamesThisMonth();
  }

  Future<List<Game>> getGamesThisMonth() {
    return repository.getGamesThisMonth();
  }

  Future<List<Game>> getGamesNextMonth() {
    return repository.getGamesNextMonth();
  }

  Future<List<Game>> getGamesThisAndNextTwoMonths() {
    return repository.getGamesThisAndNextTwoMonths();
  }
}
