// ignore: prefer_library_prefixes
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'igdb_repository.dart';

class IGDBRepositoryImpl implements IGDBRepository {
  final Dio dio;

  const IGDBRepositoryImpl({
    required this.dio,
  });

  @override
  Future<List<Game>> getOncomingGamesThisMonth() async {
    final currentTimeStamp = _getCurrentTimestamp(DateTime.now().toUtc());
    final endOfMonthTimestamp =
        _getLastMinuteOfMonthTimestamp(DateTime.now().toUtc());

    try {
      final response = await dio.post(
        '/games',
        data: 'fields *, platforms.*, cover.*; '
            'where status = null & first_release_date >= $currentTimeStamp & first_release_date < $endOfMonthTimestamp; '
            'limit 500; '
            'sort first_release_date asc;',
      );

      if (response.statusCode == 200) {
        List<Game> list = [];

        if (response.data is List) {
          list = List<Game>.from(
            response.data.map(
              (gameJson) => Game.fromJson(
                gameJson as Map<String, dynamic>,
              ),
            ),
          );
        }

        return list;
      } else {
        log('Failed to retrieve games: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('DioError while retrieving games: $e');
      return [];
    } catch (e) {
      log('Error while retrieving games: $e');
      return [];
    }
  }

  @override
  Future<List<Game>> getGamesThisMonth() async {
    final startOfMonthTimestamp =
        _getFirstMinuteOfMonthTimestamp(DateTime.now().toUtc());
    final endOfMonthTimestamp =
        _getLastMinuteOfMonthTimestamp(DateTime.now().toUtc());

    try {
      final response = await dio.post(
        '/games',
        data: 'fields *, platforms.*, cover.*; '
            'where status = null & first_release_date >= $startOfMonthTimestamp & first_release_date < $endOfMonthTimestamp; '
            'limit 500; '
            'sort first_release_date asc;',
      );

      if (response.statusCode == 200) {
        List<Game> list = [];

        if (response.data is List) {
          list = List<Game>.from(
            response.data.map(
              (gameJson) => Game.fromJson(
                gameJson as Map<String, dynamic>,
              ),
            ),
          );
        }

        return list;
      } else {
        log('Failed to retrieve games: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('DioError while retrieving games: $e');
      return [];
    } catch (e) {
      log('Error while retrieving games: $e');
      return [];
    }
  }

  @override
  Future<List<Game>> getGamesNextMonth() async {
    final startOfMonthTimestamp =
        _getFirstMinuteOfNextMonthTimestamp(DateTime.now().toUtc());
    final endOfMonthTimestamp =
        _getLastMinuteOfNextMonthTimestamp(DateTime.now().toUtc());

    try {
      final response = await dio.post(
        '/games',
        data: 'fields *, platforms.*, cover.*; '
            'where status = null & first_release_date >= $startOfMonthTimestamp & first_release_date < $endOfMonthTimestamp; '
            'limit 500; '
            'sort first_release_date asc;',
      );

      if (response.statusCode == 200) {
        List<Game> list = [];

        if (response.data is List) {
          list = List<Game>.from(
            response.data.map(
              (gameJson) => Game.fromJson(
                gameJson as Map<String, dynamic>,
              ),
            ),
          );
        }

        return list;
      } else {
        log('Failed to retrieve games: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('DioError while retrieving games: $e');
      return [];
    } catch (e) {
      log('Error while retrieving games: $e');
      return [];
    }
  }

  @override
  Future<List<Game>> getGamesThisAndNextTwoMonths() async {
    final startOfMonthTimestamp =
        _getFirstMinuteOfMonthTimestamp(DateTime.now().toUtc());
    final endOfMonthTimestamp =
        _getLastMinuteOfMonthAfter2Timestamp(DateTime.now().toUtc());

    try {
      final response = await dio.post(
        '/games',
        data: 'fields *, platforms.*, cover.*; '
            'where status = null & first_release_date >= $startOfMonthTimestamp & first_release_date < $endOfMonthTimestamp; '
            'limit 500; '
            'sort first_release_date asc;',
      );

      if (response.statusCode == 200) {
        List<Game> list = [];

        if (response.data is List) {
          list = List<Game>.from(
            response.data.map(
              (gameJson) => Game.fromJson(
                gameJson as Map<String, dynamic>,
              ),
            ),
          );
        }

        return list;
      } else {
        log('Failed to retrieve games: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      log('DioError while retrieving games: $e');
      return [];
    } catch (e) {
      log('Error while retrieving games: $e');
      return [];
    }
  }

  int _getCurrentTimestamp(DateTime now) =>
      DateTime.utc(now.year, now.month, now.day).millisecondsSinceEpoch ~/ 1000;

  int _getFirstMinuteOfMonthTimestamp(DateTime now) =>
      DateTime.utc(now.year, now.month, 1).millisecondsSinceEpoch ~/ 1000;

  int _getFirstMinuteOfNextMonthTimestamp(DateTime now) =>
      DateTime.utc(now.year, now.month + 1, 1).millisecondsSinceEpoch ~/ 1000;

  int _getLastMinuteOfMonthTimestamp(DateTime now) {
    DateTime firstDayOfNextMonth = DateTime.utc(now.year, now.month + 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    DateTime lastMinuteOfTheMonth = DateTime.utc(lastDayOfCurrentMonth.year,
        lastDayOfCurrentMonth.month, lastDayOfCurrentMonth.day, 23, 59);

    return lastMinuteOfTheMonth.millisecondsSinceEpoch ~/ 1000;
  }

  int _getLastMinuteOfNextMonthTimestamp(DateTime now) {
    DateTime firstDayOfMonthAfterNext =
        DateTime.utc(now.year, now.month + 2, 1);
    DateTime lastDayOfNextMonth =
        firstDayOfMonthAfterNext.subtract(const Duration(days: 1));
    DateTime lastMinuteOfTheMonth = DateTime.utc(lastDayOfNextMonth.year,
        lastDayOfNextMonth.month, lastDayOfNextMonth.day, 23, 59);

    return lastMinuteOfTheMonth.millisecondsSinceEpoch ~/ 1000;
  }

  int _getLastMinuteOfMonthAfter2Timestamp(DateTime now) {
    DateTime firstDayOfMonthAfterTwo = DateTime.utc(now.year, now.month + 3, 1);
    DateTime lastDayOfNext2Month =
        firstDayOfMonthAfterTwo.subtract(const Duration(days: 1));
    DateTime lastMinuteOfTheMonth = DateTime.utc(lastDayOfNext2Month.year,
        lastDayOfNext2Month.month, lastDayOfNext2Month.day, 23, 59);

    return lastMinuteOfTheMonth.millisecondsSinceEpoch ~/ 1000;
  }
}
