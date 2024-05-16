class EnvConfig {
  late Map<String, dynamic> _envMap;

  EnvConfig();

  void setEnv(Map<String, dynamic> envMap) {
    _envMap = envMap;
  }

  Map<String, dynamic> get envMap => _envMap;
  String get twitchClientId => _envMap['twitchClientId'] ?? '';
  String get twitchClientSecret => _envMap['twitchClientSecret'] ?? '';
  String get igdbAuthTokenURL => _envMap['igdbAuthTokenURL'] ?? '';
  String get igdbBaseUrl => _envMap['igdbBaseUrl'] ?? '';
}
