/// The Twitch OAuth object used to serialize the oauth response
///
/// @property access_token Your Twitch Access Token
/// @property expires_in The token expiry time
/// @property token_type The token type
class TwitchToken {
  final String accessToken;
  final int expiresIn;
  final String tokenType;

  const TwitchToken({
    required this.accessToken,
    required this.expiresIn,
    required this.tokenType,
  });

  // Optionally, if you plan to convert this object to JSON (e.g., for storage),
  // you can include a method to do so:
  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'expires_in': expiresIn,
    'token_type': tokenType,
  };

  // Similarly, you can include a factory constructor to instantiate from JSON:
  factory TwitchToken.fromJson(Map<String, dynamic> json) {
    return TwitchToken(
      accessToken: json['access_token'],
      expiresIn: json['expires_in'],
      tokenType: json['token_type'],
    );
  }
}
