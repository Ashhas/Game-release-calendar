import 'package:game_release_calendar/src/theme/app_theme_mode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  final _themeKey = 'app_theme_mode';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Setters
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs?.setString(_themeKey, mode.name);
  }

  // Getters
  String? getString(String key) => _prefs?.getString(key);

  bool? getBool(String key) => _prefs?.getBool(key);

  int? getInt(String key) => _prefs?.getInt(key);

  AppThemeMode getThemeMode() {
    final value = _prefs?.getString(_themeKey);
    return AppThemeModeExtension.fromString(value ?? 'light');
  }

  // Utility
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
