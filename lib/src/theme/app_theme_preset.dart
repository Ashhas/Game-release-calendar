import 'package:flutter/material.dart';

enum AppThemePreset {
  // Brightness modes
  light,
  dark,
  system,

  // Color schemes
  blueGrey,
  indigo,
  teal,
  amber,
  red,
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
      case AppThemePreset.blueGrey:
        return 'blueGrey';
      case AppThemePreset.indigo:
        return 'indigo';
      case AppThemePreset.teal:
        return 'teal';
      case AppThemePreset.amber:
        return 'amber';
      case AppThemePreset.red:
        return 'red';
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
      case AppThemePreset.blueGrey:
        return 'Blue Grey';
      case AppThemePreset.indigo:
        return 'Indigo';
      case AppThemePreset.teal:
        return 'Teal';
      case AppThemePreset.amber:
        return 'Amber';
      case AppThemePreset.red:
        return 'Red';
    }
  }

  /// Returns true if this is a brightness preset (light/dark/system)
  bool get isBrightnessPreset {
    return this == AppThemePreset.light ||
        this == AppThemePreset.dark ||
        this == AppThemePreset.system;
  }

  /// Returns true if this is a color preset
  bool get isColorPreset {
    return !isBrightnessPreset;
  }

  /// Returns the seed color for themes
  Color? get seedColor {
    switch (this) {
      case AppThemePreset.blueGrey:
        return const Color(0xFF819FC3); // Your custom blue-grey
      case AppThemePreset.indigo:
        return Colors.indigo;
      case AppThemePreset.teal:
        return Colors.teal;
      case AppThemePreset.amber:
        return Colors.amber;
      case AppThemePreset.red:
        return Colors.red;
      case AppThemePreset.light:
      case AppThemePreset.dark:
      case AppThemePreset.system:
        return null; // Use default or previously selected color
    }
  }

  /// Returns the brightness for this theme
  Brightness? get brightness {
    switch (this) {
      case AppThemePreset.light:
        return Brightness.light;
      case AppThemePreset.dark:
        return Brightness.dark;
      case AppThemePreset.system:
      case AppThemePreset.blueGrey:
      case AppThemePreset.indigo:
      case AppThemePreset.teal:
      case AppThemePreset.amber:
      case AppThemePreset.red:
        return null; // System or color presets don't define brightness
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
      case AppThemePreset.blueGrey:
      case AppThemePreset.indigo:
      case AppThemePreset.teal:
      case AppThemePreset.amber:
      case AppThemePreset.red:
        return ThemeMode.system; // Color presets follow system by default
    }
  }

  static AppThemePreset fromString(String value) {
    return AppThemePreset.values.firstWhere(
      (e) => e.name == value,
      orElse: () => AppThemePreset.system,
    );
  }
}
