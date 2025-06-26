import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class SharedPrefsService {
  final _themePresetKey = 'app_theme_preset';

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

  /// Save theme preset
  Future<bool> setThemePreset(AppThemePreset preset) async {
    try {
      return await _prefs?.setString(_themePresetKey, preset.name) ?? false;
    } catch (e) {
      return false;
    }
  }

  // Getters
  String? getString(String key) => _prefs?.getString(key);

  bool? getBool(String key) => _prefs?.getBool(key);

  int? getInt(String key) => _prefs?.getInt(key);

  /// Get theme preset
  AppThemePreset getThemePreset() {
    try {
      final value = _prefs?.getString(_themePresetKey);
      return AppThemePresetExtension.fromString(value ?? 'system');
    } catch (e) {
      return AppThemePreset.system; // Safe fallback
    }
  }

  // Utility
  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
