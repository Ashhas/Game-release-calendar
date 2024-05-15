import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class IGDBService {
  final IGDBRepository _repository;

  IGDBService._internal(this._repository);

  static IGDBService? _instance;

  factory IGDBService({required IGDBRepository repository}) {
    _instance ??= IGDBService._internal(repository);
    return _instance!;
  }

  // Static getter to provide the singleton instance
  static IGDBService get instance {
    if (_instance == null) {
      throw Exception(
          "IGDBService has not been initialized. Call the constructor first.");
    }
    return _instance!;
  }

  Future<List<Game>> getOncomingGamesThisMonth() {
    return _repository.getOncomingGamesThisMonth();
  }

  Future<List<Game>> getGamesThisMonth() {
    return _repository.getGamesThisMonth();
  }

  Future<List<Game>> getGamesNextMonth() {
    return _repository.getGamesNextMonth();
  }
}
