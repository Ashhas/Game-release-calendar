import 'dart:developer' as developer;
import 'dart:io';

import 'package:dio/dio.dart';

import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';
import 'package:game_release_calendar/src/utils/retry_helper.dart';
import 'igdb_repository.dart';

class IGDBRepositoryImpl implements IGDBRepository {
  final Dio dio;

  const IGDBRepositoryImpl({
    required this.dio,
  });


  @override
  Future<List<Game>> getGames(String query) async {
    return RetryHelper.retry(() async {
      try {
        final response = await dio.post(
          '/games',
          data: query,
        );

        if (response.statusCode == 200) {
          if (response.data is List) {
            return List<Game>.from(
              response.data.map(
                (gameJson) => Game.fromJson(
                  gameJson as Map<String, dynamic>,
                ),
              ),
            );
          } else {
            throw const ParseException('Invalid response format: expected List');
          }
        } else {
          throw ApiException('Failed to retrieve games', response.statusCode);
        }
      } on DioException catch (e) {
        developer.log('DioError while retrieving games: ${e.type} - ${e.message}');
        throw _handleDioException(e);
      } catch (e) {
        if (e is AppException) {
          rethrow;
        }
        developer.log('Unexpected error while retrieving games: $e');
        throw ParseException('Failed to retrieve games: ${e.toString()}');
      }
    });
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const TimeoutException();
      
      case DioExceptionType.connectionError:
        if (e.error is SocketException) {
          return const NoInternetException();
        }
        return NetworkException('Connection failed: ${e.message}');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?.toString() ?? e.message ?? 'Unknown error';
        
        switch (statusCode) {
          case 401:
            return const TokenExpiredException();
          case 403:
            return const AuthenticationException('Invalid credentials');
          case 429:
            return const RateLimitException();
          case 500:
          case 502:
          case 503:
          case 504:
            return ServerException(message);
          default:
            return ApiException(message, statusCode);
        }
      
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled');
      
      case DioExceptionType.unknown:
      default:
        return NetworkException('Network error: ${e.message}');
    }
  }
}
