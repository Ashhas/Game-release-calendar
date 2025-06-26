import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class ThemeCubit extends Cubit<AppThemePreset> {
  final SharedPrefsService prefsService;

  ThemeCubit(this.prefsService) : super(prefsService.getThemePreset());

  /// Sets the theme preset and persists it
  Future<void> setThemePreset(AppThemePreset preset) async {
    try {
      final success = await prefsService.setThemePreset(preset);
      if (success) {
        emit(preset);
        log('Theme preset changed to: ${preset.displayName}');
      }
    } catch (e) {
      log('Error saving theme preset: $e');
    }
  }

  /// Current theme preset
  AppThemePreset get currentThemePreset => state;

  /// Whether current theme is system mode
  bool get isSystemMode => state == AppThemePreset.system;

  /// Gets the theme mode for MaterialApp
  ThemeMode get themeMode => state.themeMode;

  /// Gets the seed color for the current theme
  Color? get seedColor => state.seedColor;

  /// Gets the brightness for the current theme
  Brightness? get brightness => state.brightness;

  /// Resets to default theme (system)
  Future<void> resetToDefault() async {
    await setThemePreset(AppThemePreset.system);
  }
}
