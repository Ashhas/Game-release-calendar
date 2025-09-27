import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';
import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/app_colors.dart';

class CustomTheme {
  CustomTheme._();

  static const double borderRadiusValue = 8.0;

  // Theme caching for performance optimization
  static final Map<Color?, ThemeData> _lightThemeCache = {};
  static final Map<Color?, ThemeData> _darkThemeCache = {};
  static final Map<Color?, ColorScheme> _lightColorSchemeCache = {};
  static final Map<Color?, ColorScheme> _darkColorSchemeCache = {};

  /// Creates a light ColorScheme with accent color but standard backgrounds
  static ColorScheme _accentLightColorScheme(Color accentColor) {
    return _lightColorSchemeCache.putIfAbsent(accentColor, () {
      // Generate a color scheme from the accent but override backgrounds to be standard
      final generatedScheme = ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.light,
      );

      return generatedScheme.copyWith(
        // Force standard light backgrounds
        surface: const Color(0xFFFFFFFF), // Pure white
        surfaceContainerHighest: const Color(0xFFF5F5F5), // Light grey
        onSurface: const Color(0xFF1A1A1A), // Dark text
        onSurfaceVariant: const Color(0xFF666666), // Medium grey text
      );
    });
  }

  static ColorScheme _accentDarkColorScheme(Color accentColor) {
    return _darkColorSchemeCache.putIfAbsent(accentColor, () {
      // Generate a color scheme from the accent but override backgrounds to be standard
      final generatedScheme = ColorScheme.fromSeed(
        seedColor: accentColor,
        brightness: Brightness.dark,
      );

      return generatedScheme.copyWith(
        // Force standard dark backgrounds
        surface: const Color(0xFF121212), // Standard Material dark surface
        surfaceContainerHighest: const Color(0xFF1E1E1E), // Slightly lighter dark
        onSurface: const Color(0xFFE0E0E0), // Light text
        onSurfaceVariant: const Color(0xFFB0B0B0), // Medium light text
      );
    });
  }

  /// Generates light theme with optional custom color scheme
  static ThemeData lightTheme({Color? seedColor}) {
    return _lightThemeCache.putIfAbsent(seedColor, () {
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
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
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
    });
  }

  /// Generates dark theme with optional custom color scheme
  static ThemeData darkTheme({Color? seedColor}) {
    return _darkThemeCache.putIfAbsent(seedColor, () {
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
        cardTheme: CardTheme(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
        ),
        chipTheme: ChipThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: const BorderRadius.all(Radius.circular(borderRadiusValue)),
          ),
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
    });
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

  /// Clears theme cache (useful for development or memory management)
  static void clearThemeCache() {
    _lightThemeCache.clear();
    _darkThemeCache.clear();
    _lightColorSchemeCache.clear();
    _darkColorSchemeCache.clear();
  }
}
