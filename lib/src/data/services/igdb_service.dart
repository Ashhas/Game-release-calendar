import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/utils/constants.dart';

class IGDBService {
  final IGDBRepository repository;

  const IGDBService({
    required this.repository,
  });

  Future<List<Game>> getGames({
    required String? nameQuery,
    required GameFilter filter,
    int offset = 0,
  }) async {
    return repository.getGames(
      _buildQuery(
        nameQuery,
        filter,
        offset: offset,
      ),
    );
  }

  String _buildQuery(String? nameQuery, GameFilter filter, {int offset = 0}) {
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
      DateTime dateOnly = DateTime.now();
      DateTime withoutTime =
          DateTime(dateOnly.year, dateOnly.month, dateOnly.day);

      final currentTimestamp = withoutTime.millisecondsSinceEpoch ~/ 1000;
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

    final isSearchQuery = nameQuery != null && nameQuery.isNotEmpty;

    final query = [
      if (isSearchQuery) 'search "$nameQuery";',
      'fields *, platforms.*, cover.*, release_dates.*;',
      whereClause,
      'limit ${Constants.gameRequestLimit};',
      'offset $offset;',
      if (!isSearchQuery) 'sort first_release_date asc;'
    ].join(' ');

    return query;
  }
}
