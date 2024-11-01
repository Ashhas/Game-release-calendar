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
  Future<List<Game>> getGames(String query) async {
    try {
      final response = await dio.post(
        '/games',
        data: query,
      );

      if (response.statusCode == 200 && response.data is List) {
        return List<Game>.from(
          response.data.map(
            (gameJson) => Game.fromJson(
              gameJson as Map<String, dynamic>,
            ),
          ),
        );
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
}
