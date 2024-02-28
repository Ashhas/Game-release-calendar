import 'package:dio/dio.dart';
import 'package:game_release_calendar/src/models/game.dart';
import 'package:game_release_calendar/src/services/dio_interceptor.dart';
import 'package:game_release_calendar/src/services/twitch_service.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class IGDBService {
  final String clientId;
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.igdb.com/v4',
    ),
  );

  factory IGDBService({
    required String clientId,
  }) =>
      _instance = IGDBService._internal(
        clientId: clientId,
      );

  IGDBService._internal({
    required this.clientId,
  }) {
    _addAuthHeaders();
  }

  /// the one and only instance of this singleton
  static late IGDBService _instance;

  static IGDBService get instance {
    return _instance;
  }

  Future<void> _addAuthHeaders() async {
    final accessToken = await TwitchAuthService().getStoredToken();

    dio.options.headers = {
      'Client-ID': clientId,
      'Authorization': 'Bearer ${accessToken.toString()}',
    };
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  Future<List<Game>> getGames() async {
    try {
      final response = await dio.post(
        '/games',
        data: 'fields *;',
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
        print('Failed to retrieve games: ${response.statusCode}');
        return [];
      }
    } on DioException catch (e) {
      print('DioError while retrieving games: $e');
      return [];
    } catch (e) {
      print('Error while retrieving games: $e');
      return [];
    }
  }
}
