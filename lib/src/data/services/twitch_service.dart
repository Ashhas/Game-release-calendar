import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:game_release_calendar/src/domain/models/twitch_token.dart';

class TwitchAuthService {
  TwitchAuthService({
    required this.clientId,
    required this.clientSecret,
    required this.twitchOauthTokenURL,
  });

  final String clientId;
  final String clientSecret;
  final String twitchOauthTokenURL;
  final storage = const FlutterSecureStorage(); // Secure storage instance
  final Dio dio = Dio();

  /// Authenticate and store token
  Future<void> requestTokenAndStore() async {
    try {
      final response = await dio.post(
        twitchOauthTokenURL,
        queryParameters: {
          'client_id': clientId,
          'client_secret': clientSecret,
          'grant_type': 'client_credentials',
        },
      );

      if (response.statusCode == 200) {
        final twitchToken = TwitchToken.fromJson(response.data);
        await storage.write(
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

  // Method to retrieve the stored token
  Future<String?> getStoredToken() async {
    try {
      final accessToken = await storage.read(key: 'twitch_access_token') ?? '';
      return accessToken;
    } catch (e) {
      log('Error retrieving token: $e');
      return null;
    }
  }
}
