import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/app_colors.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

class CustomTheme {
  CustomTheme._();

  static const double borderRadiusValue = 8.0;

  /// Creates a light ColorScheme with exact colors (no color harmonization)
  static ColorScheme _accentLightColorScheme(Color accentColor) {
    // Use #F2F9FF for Blue Grey theme (#819FC3), otherwise derive from accent color
    final primaryContainer = accentColor == const Color(0xFF819FC3)
        ? const Color(0xFFF2F9FF)
        : Color.alphaBlend(accentColor.withValues(alpha: 0.08), Colors.white);

    final colorScheme = ColorScheme.light(
      primary: accentColor, // Exact color passed in
      primaryContainer: primaryContainer,
      secondary: accentColor, // Keep consistent
      secondaryContainer: primaryContainer,
      tertiary: const Color(0xFFC7D9E5), // Same as dark mode for consistency
      error: const Color(0xFFBA1A1A),
      surface: const Color(0xFFFFFFFF),
      onSurface: const Color(0xFF1A1A1A),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onTertiary: const Color(0xFF000000), // Black text on light blue background
      onError: const Color(0xFFFFFFFF),
    );
    return colorScheme;
  }

  /// Creates a dark ColorScheme with exact colors (no color harmonization)
  static ColorScheme _accentDarkColorScheme(Color accentColor) {
    // Use #2A3F4D for Blue Grey theme (#819FC3), otherwise derive from accent color
    final primaryContainer = accentColor == const Color(0xFF819FC3)
        ? const Color(0xFF2A3F4D)
        : Color.alphaBlend(accentColor.withValues(alpha: 0.16), const Color(0xFF121212));

    return ColorScheme.dark(
      primary: accentColor, // Exact color passed in
      primaryContainer: primaryContainer,
      secondary: accentColor, // Keep consistent
      secondaryContainer: primaryContainer,
      tertiary: const Color(0xFFC7D9E5), // Light accent for dark mode
      error: const Color(0xFFFFB4AB),
      surface: const Color(0xFF121212),
      onSurface: const Color(0xFFE0E0E0),
      onPrimary: const Color(0xFFFFFFFF),
      onSecondary: const Color(0xFFFFFFFF),
      onTertiary: const Color(0xFF000000),
      onError: const Color(0xFF690005),
    );
  }

  /// Generates light theme with optional custom color scheme
  static ThemeData lightTheme({Color? seedColor}) {
    final ColorScheme colorScheme;

    if (seedColor != null) {
      colorScheme = _accentLightColorScheme(seedColor);
    } else {
      final themeData = ThemeData.light(useMaterial3: true);
      colorScheme = themeData.colorScheme;
    }

    return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
          backgroundColor: colorScheme.primaryContainer,
          labelStyle: TextStyle(color: colorScheme.primary),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        extensions: <ThemeExtension>[
          AppSpacings.defaultValues,
          AppColors.light,
        ],
      );
  }

  /// Generates dark theme with optional custom color scheme
  static ThemeData darkTheme({Color? seedColor}) {
    final ColorScheme colorScheme;

    if (seedColor != null) {
      colorScheme = _accentDarkColorScheme(seedColor);
    } else {
      final themeData = ThemeData.dark(useMaterial3: true);
      colorScheme = themeData.colorScheme;
    }

    return ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
          backgroundColor: colorScheme.primaryContainer,
          labelStyle: TextStyle(color: colorScheme.primary),
          side: BorderSide(color: colorScheme.primary.withValues(alpha: 0.2)),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.outline),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.outline.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            borderSide: BorderSide(color: colorScheme.primary, width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
            ),
          ),
        ),
        extensions: <ThemeExtension>[
          AppSpacings.defaultValues,
          AppColors.dark,
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
