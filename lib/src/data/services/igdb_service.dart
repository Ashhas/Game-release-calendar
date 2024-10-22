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

    if (filter.platformChoices.isNotEmpty) {
      final platformIds = filter.platformChoices
          .map((choice) => choice.id.toString())
          .join(', ');

      filterConditions.add('platforms = ($platformIds)');
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

    // If filterConditions is empty or no start date is provided, use the current date
    if (filterConditions.isEmpty || filter.releaseDateRange?.start == null) {
      filterConditions.add(
          'first_release_date >= ${DateTime.now().millisecondsSinceEpoch ~/ 1000}');
    }

    // Create a where clause with the filter conditions.
    String whereClause = 'where ${filterConditions.join(' & ')};';

    String query = 'fields *, platforms.*, cover.*; '
        '$whereClause '
        'limit 500; '
        'sort first_release_date asc;';

    return query;
  }
}
