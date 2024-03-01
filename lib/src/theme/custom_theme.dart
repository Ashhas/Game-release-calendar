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
    );
  }
}
