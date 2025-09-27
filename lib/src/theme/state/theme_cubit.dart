import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

/// Theme state that handles both color scheme and brightness
class ThemeState {
  const ThemeState({
    required this.colorPreset,
    required this.brightnessMode,
  });

  final AppThemePreset colorPreset;
  final AppThemePreset brightnessMode;

  ThemeState copyWith({
    AppThemePreset? colorPreset,
    AppThemePreset? brightnessMode,
  }) {
    return ThemeState(
      colorPreset: colorPreset ?? this.colorPreset,
      brightnessMode: brightnessMode ?? this.brightnessMode,
    );
  }

  /// Gets the effective seed color
  Color? get seedColor => colorPreset.seedColor;

  /// Gets the effective theme mode
  ThemeMode get themeMode => brightnessMode.themeMode;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ThemeState &&
        other.colorPreset == colorPreset &&
        other.brightnessMode == brightnessMode;
  }

  @override
  int get hashCode => colorPreset.hashCode ^ brightnessMode.hashCode;
}

class ThemeCubit extends Cubit<ThemeState> {
  final SharedPrefsService prefsService;

  ThemeCubit(this.prefsService)
      : super(
          ThemeState(
            colorPreset: _getStoredColorPreset(prefsService),
            brightnessMode: _getStoredBrightnessMode(prefsService),
          ),
        );

  static AppThemePreset _getStoredColorPreset(SharedPrefsService prefs) {
    final stored = prefs.getColorPreset();
    return stored.isColorPreset ? stored : AppThemePreset.blueGrey;
  }

  static AppThemePreset _getStoredBrightnessMode(SharedPrefsService prefs) {
    final stored = prefs.getBrightnessPreset();
    return stored.isBrightnessPreset ? stored : AppThemePreset.system;
  }

  /// Sets the color preset and persists it
  Future<void> setColorPreset(AppThemePreset preset) async {
    if (!preset.isColorPreset) return;

    try {
      final newState = state.copyWith(colorPreset: preset);
      emit(newState);
      await _persistState();
      dev.log('Color preset changed to: ${preset.displayName}');
    } catch (e) {
      dev.log('Error saving color preset: $e');
    }
  }

  /// Sets the brightness mode and persists it
  Future<void> setBrightnessMode(AppThemePreset mode) async {
    if (!mode.isBrightnessPreset) return;

    try {
      final newState = state.copyWith(brightnessMode: mode);
      emit(newState);
      await _persistState();
      dev.log('Brightness mode changed to: ${mode.displayName}');
    } catch (e) {
      dev.log('Error saving brightness mode: $e');
    }
  }

  /// Legacy method for backward compatibility
  Future<void> setThemePreset(AppThemePreset preset) async {
    if (preset.isColorPreset) {
      await setColorPreset(preset);
    } else {
      await setBrightnessMode(preset);
    }
  }

  Future<void> _persistState() async {
    // Save both color and brightness presets separately
    await prefsService.setColorPreset(state.colorPreset);
    await prefsService.setBrightnessPreset(state.brightnessMode);
    // Keep legacy method for backward compatibility
    await prefsService.setThemePreset(state.brightnessMode);
  }

  /// Current color preset
  AppThemePreset get currentColorPreset => state.colorPreset;

  /// Current brightness mode
  AppThemePreset get currentBrightnessMode => state.brightnessMode;

  /// Whether current theme is system mode
  bool get isSystemMode => state.brightnessMode == AppThemePreset.system;

  /// Gets the theme mode for MaterialApp
  ThemeMode get themeMode => state.themeMode;

  /// Gets the seed color for the current theme
  Color? get seedColor => state.seedColor;

  /// Resets to default theme (system + blueGrey)
  Future<void> resetToDefault() async {
    emit(const ThemeState(
      colorPreset: AppThemePreset.blueGrey,
      brightnessMode: AppThemePreset.system,
    ));
    await _persistState();
  }
}
