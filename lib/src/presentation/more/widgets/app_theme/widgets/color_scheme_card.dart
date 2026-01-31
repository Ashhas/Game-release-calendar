import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:game_release_calendar/src/theme/app_theme_preset.dart';
import 'package:game_release_calendar/src/theme/state/theme_cubit.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import 'color_preview.dart';

/// A card widget for selecting color schemes in the theme settings
class ColorSchemeCard extends StatelessWidget {
  const ColorSchemeCard({
    super.key,
    required this.preset,
    required this.title,
    required this.color,
    required this.isSelected,
  });

  final AppThemePreset preset;
  final String title;
  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          context.read<ThemeCubit>().setColorPreset(preset);
        },
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: Container(
          padding: EdgeInsets.all(context.spacings.s),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(12)),
            border: Border.fromBorderSide(
              BorderSide(
                color: isSelected
                    ? color // Use the card's own color
                    : Theme.of(
                        context,
                      ).colorScheme.outline.withValues(alpha: 0.3),
                width: isSelected ? 2 : 1,
              ),
            ),
            color: isSelected
                ? Theme.of(
                    context,
                  ).colorScheme.primaryContainer.withValues(alpha: 0.3)
                : Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              ColorPreview(color: color),
              SizedBox(width: context.spacings.s),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: color, // Use the card's own color
                  size: 20,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
