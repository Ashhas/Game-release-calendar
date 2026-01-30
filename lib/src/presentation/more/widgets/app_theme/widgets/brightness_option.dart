import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/state/theme_cubit.dart';

/// A list tile widget for selecting brightness modes in the theme settings.
/// Must be used within a RadioGroup<AppThemePreset> ancestor.
class BrightnessOption extends StatelessWidget {
  const BrightnessOption({
    super.key,
    required this.preset,
    required this.title,
    required this.icon,
    this.subtitle,
  });

  final AppThemePreset preset;
  final String title;
  final String? subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Radio<AppThemePreset>(value: preset),
      onTap: () {
        context.read<ThemeCubit>().setBrightnessMode(preset);
      },
    );
  }
}
