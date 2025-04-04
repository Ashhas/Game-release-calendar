import 'package:flutter/material.dart';

import 'package:moon_design/moon_design.dart';

import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

class CustomTheme {
  CustomTheme._();

  static const double borderRadiusValue = 8.0;

  static MoonTokens _lightTokens = MoonTokens.light.copyWith(
    colors: MoonColors.light.copyWith(
      piccolo: Colors.blue,
    ),
  );

  static MoonTokens _darkTokens = MoonTokens.dark.copyWith(
    colors: MoonColors.dark.copyWith(
      piccolo: Colors.blue,
    ),
  );

  static ThemeData lightTheme = ThemeData.light().copyWith(
    extensions: <ThemeExtension>[
      AppSpacings.defaultValues,
      MoonTheme(
        tokens: _lightTokens,
      )
    ],
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    extensions: <ThemeExtension>[
      AppSpacings.defaultValues,
      MoonTheme(
        tokens: _darkTokens,
      )
    ],
  );
}
