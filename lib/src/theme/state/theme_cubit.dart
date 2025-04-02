import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/theme/app_theme_mode.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SharedPrefsService prefsService;

  ThemeCubit(this.prefsService)
      : super(prefsService.getThemeMode().toMaterialThemeMode);

  void setThemeMode(AppThemeMode mode) {
    prefsService.setThemeMode(mode);
    emit(mode.toMaterialThemeMode);
  }

  bool get isDarkMode => state == ThemeMode.dark;
}
