import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/custom_theme.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

extension ThemeExtension on BuildContext {
  CustomTheme get customTheme => Theme.of(this).extension<CustomTheme>()!;

  AppSpacings get spacings => Theme.of(this).extension<AppSpacings>()!;
}
