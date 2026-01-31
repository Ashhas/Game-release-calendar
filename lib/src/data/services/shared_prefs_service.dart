import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class SharedPrefsService {
  final _themePresetKey = 'app_theme_preset';
  final _colorPresetKey = 'app_color_preset';
  final _brightnessPresetKey = 'app_brightness_preset';
  final _experimentalFeaturesEnabledKey = 'experimental_features_enabled';
  final _scrollbarEnabledKey = 'experimental_scrollbar_enabled';
  final _analyticsConsentKey = 'analytics_consent';
  final _analyticsConsentAskedKey = 'analytics_consent_asked';
  final _crashLogsConsentKey = 'crash_logs_consent';
  final _showEroticContentDefaultKey = 'show_erotic_content_default';

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
      return await _prefs?.setString(_brightnessPresetKey, preset.name) ??
          false;
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

  /// Returns true if user has consented to analytics. Defaults to false (opt-in).
  bool getAnalyticsConsent() {
    try {
      return _prefs?.getBool(_analyticsConsentKey) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('SharedPrefsService: Failed to read analytics consent - $e');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  Future<bool> setAnalyticsConsent(bool consented) async {
    try {
      return await _prefs?.setBool(_analyticsConsentKey, consented) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('SharedPrefsService: Failed to save analytics consent - $e');
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  /// Returns true if we've already asked the user for analytics consent.
  bool hasAskedAnalyticsConsent() {
    try {
      return _prefs?.getBool(_analyticsConsentAskedKey) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to read consent asked status - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  Future<bool> setAnalyticsConsentAsked(bool asked) async {
    try {
      return await _prefs?.setBool(_analyticsConsentAskedKey, asked) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to save consent asked status - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  /// Returns true if user has consented to crash logs. Defaults to false (opt-in).
  bool getCrashLogsConsent() {
    try {
      return _prefs?.getBool(_crashLogsConsentKey) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to read crash logs consent - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  Future<bool> setCrashLogsConsent(bool consented) async {
    try {
      return await _prefs?.setBool(_crashLogsConsentKey, consented) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to save crash logs consent - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  /// Returns true if erotic content should be shown by default.
  /// Defaults to false (filter out erotic content).
  bool getShowEroticContentDefault() {
    try {
      return _prefs?.getBool(_showEroticContentDefaultKey) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to read erotic content default - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
      return false;
    }
  }

  Future<bool> setShowEroticContentDefault(bool show) async {
    try {
      return await _prefs?.setBool(_showEroticContentDefaultKey, show) ?? false;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint(
          'SharedPrefsService: Failed to save erotic content default - $e',
        );
        debugPrintStack(stackTrace: stackTrace);
      }
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
