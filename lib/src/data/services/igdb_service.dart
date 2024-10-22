import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class IGDBService {
  final IGDBRepository repository;

  const IGDBService({
    required this.repository,
  });

  Future<List<Game>> getGames(GameFilter filter) {
    return repository.getGames(_buildQueryParameters(filter));
  }

  String _buildQueryParameters(GameFilter filter) {
    List<String> filterConditions = [];

    if (filter.platform != null) {
      filterConditions.add('platforms = (${filter.platform!.id.toString()})');
    }

    if (filter.releaseDateRange?.start != null) {
      final fromTimestamp =
          filter.releaseDateRange!.start.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add('first_release_date >= $fromTimestamp');
    }

    if (filter.releaseDateRange?.end != null) {
      final toTimestamp =
          filter.releaseDateRange!.end.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add('first_release_date < $toTimestamp');
    }

    // Create a where clause with the filter conditions.
    // Default value is current date.
    String whereClause = filterConditions.isNotEmpty
        ? 'where ${filterConditions.join(' & ')};'
        : 'where first_release_date >= ${DateTime.now().millisecondsSinceEpoch ~/ 1000};';

    String query = 'fields *, platforms.*, cover.*; '
        '$whereClause '
        'limit 500; '
        'sort first_release_date asc;';

    return query;
  }
}
