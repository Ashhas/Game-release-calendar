import 'package:game_release_calendar/src/data/repositories/igdb_repository.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/search_helper.dart';
import '../../utils/date_range_utility.dart';

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
    final games = await repository.getGames(
      _buildQuery(
        nameQuery,
        filter,
        offset: offset,
      ),
    );

    // Apply release precision filter if specified
    if (filter.releasePrecisionChoice != null &&
        filter.releasePrecisionChoice != ReleasePrecisionFilter.all) {
      return games.where((game) {
        // Check if any release date matches the precision filter
        return game.releaseDates?.any((releaseDate) {
          return filter.releasePrecisionChoice!.matches(releaseDate);
        }) ?? false;
      }).toList();
    }

    return games;
  }

  String _buildQuery(String? nameQuery, GameFilter filter, {int offset = 0}) {
    List<String> filterConditions = [];
    DateTime? startTimestamp;
    DateTime? endTimestamp;

    // Name search filter (with accented variants for better matching)
    if (nameQuery != null && nameQuery.isNotEmpty) {
      final normalizedQuery = SearchHelper.addAccentedVariants(nameQuery);
      if (normalizedQuery.isNotEmpty) {
        // Include original query plus up to 8 variants to balance coverage and performance
        final limitedVariants = normalizedQuery.take(8).toList();
        final searchTerms = [nameQuery, ...limitedVariants]
            .map((term) => 'name ~ *"$term"*')
            .join(' | ');
        filterConditions.add('($searchTerms)');
      } else {
        filterConditions.add('name ~ *"$nameQuery"*');
      }
    }

    // Category filter
    if (filter.categoryIds.isNotEmpty) {
      final categoryIds =
          filter.categoryIds.map((categoryId) => categoryId).join(', ');
      filterConditions.add('category = ($categoryIds)');
    }

    // Platform filter
    if (filter.platformChoices.isNotEmpty) {
      final platformIds =
          filter.platformChoices.map((choice) => choice.id).join(', ');
      filterConditions.add('platforms = ($platformIds)');
    }

    // Release date range filter
    if (filter.releaseDateChoice != null) {
      final dateRange = DateRangeUtility.getDateRangeForChoice(
        filter.releaseDateChoice!,
      );

      startTimestamp = dateRange.start;
      endTimestamp = dateRange.end;
    }

    if (startTimestamp != null) {
      final fromTimestamp = startTimestamp.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add(
          '(first_release_date >= $fromTimestamp | first_release_date = null)');
    } else {
      // Default to current date if no start is provided
      DateTime dateOnly = DateTime.now();
      DateTime withoutTime =
          DateTime(dateOnly.year, dateOnly.month, dateOnly.day);

      final currentTimestamp = withoutTime.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add(
          '(first_release_date >= $currentTimestamp | first_release_date = null)');
    }

    if (endTimestamp != null && endTimestamp != Constants.maxDateLimit) {
      final toTimestamp = endTimestamp.millisecondsSinceEpoch ~/ 1000;
      filterConditions.add(
          '(first_release_date < $toTimestamp | first_release_date = null)');
    }

    // Query construction
    final whereClause = filterConditions.isNotEmpty
        ? 'where ${filterConditions.join(' & ')};'
        : '';

    final query = [
      'fields *, platforms.*, cover.*, release_dates.*, artworks.*, category;',
      whereClause,
      'limit ${Constants.gameRequestLimit};',
      'offset $offset;',
      'sort first_release_date asc;'
    ].join(' ');

    return query;
  }
}
