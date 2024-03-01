import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import 'package:game_release_calendar/src/data/twitch_service.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

class IGDBService {
  final String clientId;
  final String igdbBaseUrl;

  late final Dio dio;

  factory IGDBService({
    required String clientId,
    required String authTokenURL,
  }) =>
      _instance = IGDBService._internal(
        clientId: clientId,
        igdbBaseUrl: authTokenURL,
      );

  IGDBService._internal({
    required this.clientId,
    required this.igdbBaseUrl,
  }) {
    dio = Dio(
      BaseOptions(
        baseUrl: igdbBaseUrl,
      ),
    );

    _addAuthHeaders();
  }

  static late IGDBService _instance;

  static IGDBService get instance {
    return _instance;
  }

  Future<void> _addAuthHeaders() async {
    final accessToken = await TwitchAuthService.instance.getStoredToken();

    dio.options.headers = {
      'Client-ID': clientId,
      'Authorization': 'Bearer ${accessToken.toString()}',
    };
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<List<Game>> getOncomingGamesThisMonth() async {
    final currentTimeStamp = _getCurrentTimestamp(
      DateTime.now().toUtc(),
    );
    final endOfMonthTimestamp = _getLastMinuteOfMonthTimestamp(
      DateTime.now().toUtc(),
    );

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

  Future<List<Game>> getGamesThisMonth() async {
    final startOfMonthTimestamp = _getFirstMinuteOfMonthTimestamp(
      DateTime.now().toUtc(),
    );
    final endOfMonthTimestamp = _getLastMinuteOfMonthTimestamp(
      DateTime.now().toUtc(),
    );

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

  int _getLastMinuteOfMonthTimestamp(DateTime now) {
    DateTime firstDayOfNextMonth = DateTime.utc(now.year, now.month + 1, 1);
    DateTime lastDayOfCurrentMonth =
        firstDayOfNextMonth.subtract(const Duration(days: 1));
    DateTime lastMinuteOfTheMonth = DateTime.utc(lastDayOfCurrentMonth.year,
        lastDayOfCurrentMonth.month, lastDayOfCurrentMonth.day, 23, 59);

    return lastMinuteOfTheMonth.millisecondsSinceEpoch ~/ 1000;
  }
}
