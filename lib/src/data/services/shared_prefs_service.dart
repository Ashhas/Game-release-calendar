import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class SharedPrefsService {
  final _themePresetKey = 'app_theme_preset';
  final _colorPresetKey = 'app_color_preset';
  final _brightnessPresetKey = 'app_brightness_preset';
  final _experimentalFeaturesEnabledKey = 'experimental_features_enabled';
  final _scrollbarEnabledKey = 'experimental_scrollbar_enabled';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await _prefs?.setInt(key, value);
  }

  Future<bool> setThemePreset(AppThemePreset preset) async {
    try {
      return await _prefs?.setString(_themePresetKey, preset.name) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setColorPreset(AppThemePreset preset) async {
    try {
      return await _prefs?.setString(_colorPresetKey, preset.name) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setBrightnessPreset(AppThemePreset preset) async {
    try {
      return await _prefs?.setString(_brightnessPresetKey, preset.name) ?? false;
    } catch (e) {
      return false;
    }
  }

  String? getString(String key) => _prefs?.getString(key);

  bool? getBool(String key) => _prefs?.getBool(key);

  int? getInt(String key) => _prefs?.getInt(key);

  AppThemePreset getThemePreset() {
    try {
      final value = _prefs?.getString(_themePresetKey);
      return AppThemePresetExtension.fromString(value ?? 'system');
    } catch (e) {
      return AppThemePreset.system;
    }
  }

  AppThemePreset getColorPreset() {
    try {
      final value = _prefs?.getString(_colorPresetKey);
      return AppThemePresetExtension.fromString(value ?? 'blueGrey');
    } catch (e) {
      return AppThemePreset.blueGrey;
    }
  }

  AppThemePreset getBrightnessPreset() {
    try {
      final value = _prefs?.getString(_brightnessPresetKey);
      return AppThemePresetExtension.fromString(value ?? 'system');
    } catch (e) {
      return AppThemePreset.system;
    }
  }

  Future<bool> setExperimentalFeaturesEnabled(bool enabled) async {
    try {
      return await _prefs?.setBool(_experimentalFeaturesEnabledKey, enabled) ??
          false;
    } catch (e) {
      return false;
    }
  }

  bool getExperimentalFeaturesEnabled() {
    try {
      return _prefs?.getBool(_experimentalFeaturesEnabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> setScrollbarEnabled(bool enabled) async {
    try {
      return await _prefs?.setBool(_scrollbarEnabledKey, enabled) ?? false;
    } catch (e) {
      return false;
    }
  }

  bool getScrollbarEnabled() {
    try {
      return _prefs?.getBool(_scrollbarEnabledKey) ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  Future<void> clear() async {
    await _prefs?.clear();
  }
}
