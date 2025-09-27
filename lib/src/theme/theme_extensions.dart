import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';
import 'package:game_release_calendar/src/theme/app_colors.dart';

extension ThemeExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;

  AppSpacings get spacings => Theme.of(this).extension<AppSpacings>()!;
}
