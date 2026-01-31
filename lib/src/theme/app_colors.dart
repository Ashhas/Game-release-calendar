import 'package:flutter/material.dart';

/// Custom color palette for the application
/// These semantic colors adapt to light/dark themes
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.primaryBlue,
    required this.lightSurface,
    required this.darkAccent,
    required this.lightBackground,
    required this.darkBackground,
    required this.tintedSurface,
    required this.success,
    required this.warning,
    required this.info,
    required this.cardBackground,
    required this.divider,
  });

  // Your custom palette colors
  final Color primaryBlue; // #819FC3
  final Color lightSurface; // #C7D9E5
  final Color darkAccent; // #5D7C90
  final Color lightBackground; // #FFFFFF
  final Color darkBackground; // #181715
  final Color tintedSurface; // #F2F9FF

  // Semantic colors
  final Color success;
  final Color warning;
  final Color info;
  final Color cardBackground;
  final Color divider;

  /// Light theme colors based on your palette
  static const light = AppColors(
    primaryBlue: Color(0xFF819FC3),
    lightSurface: Color(0xFFC7D9E5),
    darkAccent: Color(0xFF5D7C90),
    lightBackground: Color(0xFFFFFFFF),
    darkBackground: Color(0xFF181715),
    tintedSurface: Color(0xFFF2F9FF),
    success: Color(0xFF4CAF50),
    warning: Color(0xFFFF9800),
    info: Color(0xFF2196F3),
    cardBackground: Color(0xFFF2F9FF),
    divider: Color(0xFFE0E0E0),
  );

  /// Dark theme colors adapted from your palette
  static const dark = AppColors(
    primaryBlue: Color(0xFF819FC3),
    lightSurface: Color(0xFF3A3937),
    darkAccent: Color(0xFFC7D9E5),
    lightBackground: Color(0xFF2A2927),
    darkBackground: Color(0xFF181715),
    tintedSurface: Color(0xFF2A2927),
    success: Color(0xFF66BB6A),
    warning: Color(0xFFFFB74D),
    info: Color(0xFF64B5F6),
    cardBackground: Color(0xFF2A2927),
    divider: Color(0xFF424242),
  );

  @override
  ThemeExtension<AppColors> copyWith({
    Color? primaryBlue,
    Color? lightSurface,
    Color? darkAccent,
    Color? lightBackground,
    Color? darkBackground,
    Color? tintedSurface,
    Color? success,
    Color? warning,
    Color? info,
    Color? cardBackground,
    Color? divider,
  }) {
    return AppColors(
      primaryBlue: primaryBlue ?? this.primaryBlue,
      lightSurface: lightSurface ?? this.lightSurface,
      darkAccent: darkAccent ?? this.darkAccent,
      lightBackground: lightBackground ?? this.lightBackground,
      darkBackground: darkBackground ?? this.darkBackground,
      tintedSurface: tintedSurface ?? this.tintedSurface,
      success: success ?? this.success,
      warning: warning ?? this.warning,
      info: info ?? this.info,
      cardBackground: cardBackground ?? this.cardBackground,
      divider: divider ?? this.divider,
    );
  }

  @override
  ThemeExtension<AppColors> lerp(
    covariant ThemeExtension<AppColors>? other,
    double t,
  ) {
    if (other is! AppColors) {
      return this;
    }
    return AppColors(
      primaryBlue: Color.lerp(primaryBlue, other.primaryBlue, t)!,
      lightSurface: Color.lerp(lightSurface, other.lightSurface, t)!,
      darkAccent: Color.lerp(darkAccent, other.darkAccent, t)!,
      lightBackground: Color.lerp(lightBackground, other.lightBackground, t)!,
      darkBackground: Color.lerp(darkBackground, other.darkBackground, t)!,
      tintedSurface: Color.lerp(tintedSurface, other.tintedSurface, t)!,
      success: Color.lerp(success, other.success, t)!,
      warning: Color.lerp(warning, other.warning, t)!,
      info: Color.lerp(info, other.info, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
