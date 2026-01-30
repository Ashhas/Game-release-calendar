class EnvConfig {
  final Map<String, dynamic> map;

  const EnvConfig(this.map);

  Map<String, dynamic> get envMap => map;

  // Twitch / IGDB
  String get twitchClientId => map['twitchClientId'] ?? '';
  String get twitchClientSecret => map['twitchClientSecret'] ?? '';
  String get igdbAuthTokenURL => map['igdbAuthTokenURL'] ?? '';
  String get igdbBaseUrl => map['igdbBaseUrl'] ?? '';

  // PostHog Analytics
  String get posthogApiKey => map['posthogApiKey'] ?? '';
  String get posthogHost => map['posthogHost'] ?? 'https://eu.i.posthog.com';
}
