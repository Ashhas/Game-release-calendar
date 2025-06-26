import 'package:flutter/material.dart';

import 'package:moon_design/moon_design.dart';

import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';

class CustomTheme {
  CustomTheme._();

  static const double borderRadiusValue = 8.0;

  /// Generates light theme with optional custom color scheme
  static ThemeData lightTheme({Color? seedColor}) {
    final colorScheme = seedColor != null
        ? ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.light,
          )
        : null;

    final themeData = ThemeData.light(useMaterial3: true);

    return themeData.copyWith(
      colorScheme: colorScheme ?? themeData.colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: <ThemeExtension>[
        AppSpacings.defaultValues,
        MoonTheme(
          tokens: MoonTokens.light,
        ),
      ],
    );
  }

  /// Generates dark theme with optional custom color scheme
  static ThemeData darkTheme({Color? seedColor}) {
    final colorScheme = seedColor != null
        ? ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
          )
        : null;

    final themeData = ThemeData.dark(useMaterial3: true);

    return themeData.copyWith(
      colorScheme: colorScheme ?? themeData.colorScheme,
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      extensions: <ThemeExtension>[
        AppSpacings.defaultValues,
        MoonTheme(
          tokens: MoonTokens.dark,
        ),
      ],
    );
  }

  /// Generates theme from preset
  static ThemeData fromPreset(AppThemePreset preset) {
    final seedColor = preset.seedColor;
    final brightness = preset.brightness;

    if (brightness == Brightness.light) {
      return lightTheme(seedColor: seedColor);
    } else {
      return darkTheme(seedColor: seedColor);
    }
  }

  /// Gets the appropriate theme data for the given preset and system brightness
  static ThemeData getThemeForPreset(
      AppThemePreset preset, Brightness systemBrightness) {
    // For system theme, use system brightness with default colors
    if (preset == AppThemePreset.system) {
      return systemBrightness == Brightness.light ? lightTheme() : darkTheme();
    }

    // For other presets, use the preset's defined brightness and color
    return fromPreset(preset);
  }
}
