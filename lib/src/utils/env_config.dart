class EnvConfig {
  final Map<String, dynamic> map;

  const EnvConfig(this.map);

  Map<String, dynamic> get envMap => map;
  String get twitchClientId => map['twitchClientId'] ?? '';
  String get twitchClientSecret => map['twitchClientSecret'] ?? '';
  String get igdbAuthTokenURL => map['igdbAuthTokenURL'] ?? '';
  String get igdbBaseUrl => map['igdbBaseUrl'] ?? '';
}
