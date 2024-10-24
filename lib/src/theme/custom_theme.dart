import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

class CustomTheme {
  const CustomTheme._();

  static ThemeData lightTheme() {
    return ThemeData(
      extensions: const [AppSpacings.defaultValues],
    );
  }

  static ThemeData darkTheme() {
    return ThemeData.dark().copyWith(
      extensions: const [AppSpacings.defaultValues],
      splashColor: const Color(0xFF212121),
      colorScheme: ThemeData.dark().colorScheme.copyWith(
            // Primary colors (used for buttons, active states, etc.)
            primary: Color(0xFF3D3D3D),
            onPrimary: Colors.white,

            // Secondary colors (can be used for accents or in bottom navbar)
            secondary: Color(0xFF686868),
            onSecondary: Colors.white,

            // Surface colors (used for cards, menus, background.)
            surface: Color(0xFF262626),
            onSurface: Colors.white,

            // Other colors, Searchbar background
            primaryContainer: Color(0xFF222222),
            onPrimaryContainer: Colors.white,

            // Appbar scroll
            surfaceTint: Color(0xFF262626),

            // Divider color
            outline: Color(0xFF3D3D3D),
            // Border color or dividers

            // Error colors (optional, default values for errors)
            error: Colors.red,
            onError: Colors.white,
          ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF262626),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xFF666666),
      ),
    );
  }
}
