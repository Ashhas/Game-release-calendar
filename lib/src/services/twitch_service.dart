import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TwitchAuthService {
  final String clientId;
  final String clientSecret;
  final String twitchOauthTokenURL;
  final storage = const FlutterSecureStorage(); // Secure storage instance
  final Dio dio = Dio(); // Dio instance

  factory TwitchAuthService({
    required String clientId,
    required String clientSecret,
    required String twitchOauthTokenURL,
  }) =>
      _instance = TwitchAuthService._internal(
        clientId: clientId,
        clientSecret: clientSecret,
        twitchOauthTokenURL: twitchOauthTokenURL,
      );

  TwitchAuthService._internal({
    required this.clientId,
    required this.clientSecret,
    required this.twitchOauthTokenURL,
  });

  static late TwitchAuthService _instance;

  static TwitchAuthService get instance {
    return _instance;
  }

  // Method to authenticate and store token
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
        String accessToken = response.data['access_token'];
        // Store access token securely
        await storage.write(key: 'twitch_token', value: accessToken);
        print('Token stored successfully');
      } else {
        print('Failed to authenticate with Twitch: ${response.statusCode}');
      }
    } on DioException catch (e) {
      print('DioError while authenticating with Twitch: $e');
    } catch (e) {
      print('Error while authenticating with Twitch: $e');
    }
  }

  // Method to retrieve the stored token
  Future<String?> getStoredToken() async {
    try {
      final accessToken = await storage.read(key: 'twitch_token');
      return accessToken;
    } catch (e) {
      print('Error retrieving token: $e');
      return null;
    }
  }
}
