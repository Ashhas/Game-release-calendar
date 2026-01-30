import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:game_release_calendar/src/domain/models/twitch_token.dart';

class TwitchAuthService {
  TwitchAuthService({
    required String clientId,
    required String clientSecret,
    required String twitchOauthTokenURL,
  })  : _clientId = clientId,
        _clientSecret = clientSecret,
        _twitchOauthTokenURL = twitchOauthTokenURL,
        _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  final String _clientId;
  final String _clientSecret;
  final String _twitchOauthTokenURL;
  final FlutterSecureStorage _storage;

  static Future<TwitchAuthService> create({
    required Dio dio,
    required String clientId,
    required String clientSecret,
    required String twitchOauthTokenURL,
  }) async {
    final authService = TwitchAuthService(
      clientId: clientId,
      clientSecret: clientSecret,
      twitchOauthTokenURL: twitchOauthTokenURL,
    );

    await authService.requestTokenAndStore();

    final token = await authService.getStoredToken();
    if (token != null && token.isNotEmpty) {
      dio.options.headers['Client-ID'] = clientId;
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return authService;
  }

  /// Authenticate and store token
  Future<void> requestTokenAndStore() async {
    try {
      // Use a separate Dio instance for OAuth to avoid baseUrl conflicts
      final authDio = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ),
      );
      final response = await authDio.post(
        _twitchOauthTokenURL,
        queryParameters: {
          'client_id': _clientId,
          'client_secret': _clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        final twitchToken = TwitchToken.fromJson(response.data);
        await _storage.write(
          key: 'twitch_access_token',
          value: twitchToken.accessToken,
        );
      } else {
        developer.log('Failed to authenticate with Twitch: ${response.statusCode}');
      }
    } on DioException catch (e) {
      developer.log('DioError while authenticating with Twitch: $e');
    } catch (e) {
      developer.log('Error while authenticating with Twitch: $e');
    }
  }

  Future<String?> getStoredToken() async {
    try {
      final accessToken = await _storage.read(key: 'twitch_access_token') ?? '';
      return accessToken;
    } catch (e) {
      developer.log('Error retrieving token: $e');
      return null;
    }
  }
}
