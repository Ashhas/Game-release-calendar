import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class IGDBService {
  final IGDBRepository repository;

  const IGDBService({
    required this.repository,
  });

  Future<List<Game>> getGames(GameFilter filter) {
    return repository.getGames(_buildQuery(filter));
  }

  Future<List<Game>> getGamesWithOffset({
    required GameFilter filter,
    required int offset,
  }) {
    return repository.getGames(
      _buildQuery(
        filter,
        offset: offset,
      ),
    );
  }

  String _buildQuery(GameFilter filter, {int offset = 0}) {
    List<String> filterConditions = [];

    // Platform filter
    if (filter.platformChoices.isNotEmpty) {
      final platformIds =
          filter.platformChoices.map((choice) => choice.id).join(', ');
      filterConditions.add('platforms = ($platformIds)');
    }

    // Release date range filter
    final startTimestamp = filter.releaseDateRange?.start;
    final endTimestamp = filter.releaseDateRange?.end;

    if (startTimestamp != null) {
      final fromTimestamp = startTimestamp.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add('first_release_date >= $fromTimestamp');
    } else {
      // Default to current date if no start is provided
      final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      filterConditions.add('first_release_date >= $currentTimestamp');
    }

    if (endTimestamp != null) {
      final toTimestamp = endTimestamp.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add('first_release_date < $toTimestamp');
    }

    // Query construction
    final whereClause = filterConditions.isNotEmpty
        ? 'where ${filterConditions.join(' & ')};'
        : '';

    final query = [
      'fields *, platforms.*, cover.*, release_dates.*;',
      whereClause,
      'limit 500;',
      'offset $offset;',
      'sort first_release_date asc;'
    ].join(' ');

    return query;
  }
}
