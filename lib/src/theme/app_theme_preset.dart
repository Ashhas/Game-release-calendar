import 'package:flutter/material.dart';

enum AppThemePreset {
  light,
  dark,
  system,
}

extension AppThemePresetExtension on AppThemePreset {
  String get name {
    switch (this) {
      case AppThemePreset.light:
        return 'light';
      case AppThemePreset.dark:
        return 'dark';
      case AppThemePreset.system:
        return 'system';
    }
  }

  String get displayName {
    switch (this) {
      case AppThemePreset.light:
        return 'Light';
      case AppThemePreset.dark:
        return 'Dark';
      case AppThemePreset.system:
        return 'System';
    }
  }

  /// Returns the seed color for themes (null = use default Material 3 colors)
  Color? get seedColor {
    // All basic themes use default Material 3 colors
    return null;
  }

  /// Returns the brightness for this theme
  Brightness? get brightness {
    switch (this) {
      case AppThemePreset.light:
        return Brightness.light;
      case AppThemePreset.dark:
        return Brightness.dark;
      case AppThemePreset.system:
        return null; // System will handle brightness
    }
  }

  /// Converts to Flutter's ThemeMode for MaterialApp
  ThemeMode get themeMode {
    switch (this) {
      case AppThemePreset.light:
        return ThemeMode.light;
      case AppThemePreset.dark:
        return ThemeMode.dark;
      case AppThemePreset.system:
        return ThemeMode.system;
    }
  }

  static AppThemePreset fromString(String value) {
    return AppThemePreset.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemePreset.system,
    );
  }
}