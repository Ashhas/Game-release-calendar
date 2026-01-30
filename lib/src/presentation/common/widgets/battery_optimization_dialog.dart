import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/utils/battery_optimization_helper.dart';

/// A dialog that prompts the user to disable battery optimization
/// for more reliable notification delivery.
class BatteryOptimizationDialog extends StatelessWidget {
  const BatteryOptimizationDialog({super.key});

  /// Shows the battery optimization dialog if needed.
  ///
  /// Only shows once unless:
  /// - The app is not exempt and hasn't been prompted yet
  /// - The user hasn't explicitly declined
  /// - The user explicitly requests it via settings
  ///
  /// Returns `true` if the app is already exempt or the user granted permission,
  /// `false` if the user dismissed the dialog without granting permission.
  static Future<bool> showIfNeeded(BuildContext context) async {
    // Already exempt - no need to show
    final isExempt =
        await BatteryOptimizationHelper.isIgnoringBatteryOptimizations();
    if (isExempt) {
      return true;
    }

    // User explicitly declined - respect their choice
    final hasDeclined =
        await BatteryOptimizationHelper.hasUserDeclinedOptimization();
    if (hasDeclined) {
      return false;
    }

    // Already prompted the user once - don't nag
    final hasPrompted = await BatteryOptimizationHelper.hasPromptedUser();
    if (hasPrompted) {
      return false;
    }

    if (!context.mounted) return false;

    // Mark as prompted before showing
    await BatteryOptimizationHelper.setHasPromptedUser();

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const BatteryOptimizationDialog(),
    );

    return result ?? false;
  }

  /// Force shows the dialog regardless of previous prompts.
  /// Useful for a "re-check" button in settings.
  static Future<bool> showAlways(BuildContext context) async {
    final isExempt =
        await BatteryOptimizationHelper.isIgnoringBatteryOptimizations();
    if (isExempt) {
      return true;
    }

    if (!context.mounted) return false;

    final result = await showDialog<bool>(
      context: context,
      builder: (_) => const BatteryOptimizationDialog(),
    );

    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enable Background Updates'),
      content: const Text(
        'GameWatch can check for game release date changes in the background, '
        'even when you\'re not using the app. This helps you stay informed '
        'about delays or new release dates.\n\n'
        'To enable this feature, allow the app to run without battery restrictions.',
      ),
      actions: [
        TextButton(
          onPressed: () async {
            // Save user's choice to decline
            await BatteryOptimizationHelper.setUserDeclinedOptimization();
            if (context.mounted) {
              Navigator.of(context).pop(false);
            }
          },
          child: const Text('No Thanks'),
        ),
        FilledButton(
          onPressed: () async {
            final granted =
                await BatteryOptimizationHelper.showBatteryOptimizationDialog();
            if (context.mounted) {
              Navigator.of(context).pop(granted);
            }
          },
          child: const Text('Allow'),
        ),
      ],
    );
  }
}
