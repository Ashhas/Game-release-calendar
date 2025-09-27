import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/state/theme_cubit.dart';

/// A list tile widget for selecting brightness modes in the theme settings
class BrightnessOption extends StatelessWidget {
  const BrightnessOption({
    super.key,
    required this.preset,
    required this.title,
    required this.icon,
    required this.currentBrightnessMode,
    this.subtitle,
  });

  final AppThemePreset preset;
  final String title;
  final String? subtitle;
  final IconData icon;
  final AppThemePreset currentBrightnessMode;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: subtitle != null ? Text(subtitle!) : null,
      trailing: Radio<AppThemePreset>(
        value: preset,
        groupValue: currentBrightnessMode,
        onChanged: (value) {
          if (value != null) {
            context.read<ThemeCubit>().setBrightnessMode(value);
          }
        },
      ),
      onTap: () {
        context.read<ThemeCubit>().setBrightnessMode(preset);
      },
    );
  }
}