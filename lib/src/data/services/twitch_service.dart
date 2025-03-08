// ignore: prefer_library_prefixes

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:game_release_calendar/src/domain/models/twitch_token.dart';

class TwitchAuthService {
  TwitchAuthService({
    required Dio dio,
    required String clientId,
    required String clientSecret,
    required String twitchOauthTokenURL,
  })  : _dio = dio,
        _clientId = clientId,
        _clientSecret = clientSecret,
        _twitchOauthTokenURL = twitchOauthTokenURL,
        _storage = const FlutterSecureStorage();
  final Dio _dio;
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
      dio: dio,
      clientId: clientId,
      clientSecret: clientSecret,
      twitchOauthTokenURL: twitchOauthTokenURL,
    );

    await authService.requestTokenAndStore();

    final token = await authService.getStoredToken();
    if (token != null) {
      dio.options.headers['Client-ID'] = clientId;
      dio.options.headers['Authorization'] = 'Bearer $token';
    }

    return authService;
  }

  /// Authenticate and store token
  Future<void> requestTokenAndStore() async {
    try {
      final response = await _dio.post(
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
        log('Token stored successfully');
      } else {
        log('Failed to authenticate with Twitch: ${response.statusCode}');
      }
    } on DioException catch (e) {
      log('DioError while authenticating with Twitch: $e');
    } catch (e) {
      log('Error while authenticating with Twitch: $e');
    }
  }

  Future<String?> getStoredToken() async {
    try {
      final accessToken = await _storage.read(key: 'twitch_access_token') ?? '';
      return accessToken;
    } catch (e) {
      log('Error retrieving token: $e');
      return null;
    }
  }
}
