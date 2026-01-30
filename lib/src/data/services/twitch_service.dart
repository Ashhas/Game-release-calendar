import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:game_release_calendar/src/domain/models/twitch_token.dart';

/// Service for managing Twitch OAuth authentication for IGDB API access.
///
/// Uses lazy token fetching - only makes network call if no token exists
/// or when explicitly refreshed (e.g., on 401 error).
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
        _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
        );

  final Dio _dio;
  final String _clientId;
  final String _clientSecret;
  final String _twitchOauthTokenURL;
  final FlutterSecureStorage _storage;

  /// Creates and initializes the auth service with lazy token loading.
  ///
  /// Only fetches a new token if none exists in storage. This avoids
  /// blocking app startup with a network call when a valid token is cached.
  /// Does not validate token expiration - relies on 401 errors from API
  /// calls to trigger refresh via the auth retry interceptor in main.dart.
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

    // Check for existing token first - avoid network call if possible
    final existingToken = await authService.getStoredToken();

    if (existingToken != null && existingToken.isNotEmpty) {
      // Use cached token - no network call needed
      developer.log('TwitchAuth: Using cached token');
      authService._applyTokenToHeaders(existingToken);
    } else {
      // No cached token - need to fetch one
      developer.log('TwitchAuth: No cached token, fetching new one');
      final success = await authService.refreshToken();
      if (!success) {
        developer.log(
          'TwitchAuth: WARNING - Failed to obtain initial token. '
          'API calls will fail until token is refreshed via 401 retry.',
        );
      }
    }

    return authService;
  }

  /// Applies the token to Dio headers for API requests.
  void _applyTokenToHeaders(String token) {
    _dio.options.headers['Client-ID'] = _clientId;
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  /// Refreshes the OAuth token by making a network request.
  ///
  /// Called on first launch (no cached token) or when receiving 401 errors.
  /// Returns true if token was successfully refreshed.
  Future<bool> refreshToken() async {
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
        _applyTokenToHeaders(twitchToken.accessToken);
        developer.log('TwitchAuth: Token refreshed successfully');
        return true;
      } else {
        developer.log('TwitchAuth: Failed to refresh token: ${response.statusCode}');
        return false;
      }
    } on DioException catch (e) {
      developer.log('TwitchAuth: DioError while refreshing token: $e');
      return false;
    } catch (e) {
      developer.log('TwitchAuth: Error while refreshing token: $e');
      return false;
    }
  }

  Future<String?> getStoredToken() async {
    try {
      final accessToken = await _storage.read(key: 'twitch_access_token') ?? '';
      return accessToken;
    } catch (e) {
      developer.log('TwitchAuth: Error retrieving token: $e');
      return null;
    }
  }
}
