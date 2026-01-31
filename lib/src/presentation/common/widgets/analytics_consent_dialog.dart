import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:get_it/get_it.dart';

import 'package:game_release_calendar/main.dart';
import 'package:game_release_calendar/src/data/services/shared_prefs_service.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

/// GDPR-compliant privacy consent dialog.
/// Shows on first launch to ask user for explicit consent before tracking.
class AnalyticsConsentDialog extends StatelessWidget {
  const AnalyticsConsentDialog({super.key});

  /// Shows the consent dialog if user hasn't been asked yet.
  /// Returns true if consent was given, false otherwise.
  static Future<bool> showIfNeeded(BuildContext context) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    // Don't show if we've already asked
    if (sharedPrefs.hasAskedAnalyticsConsent()) {
      return sharedPrefs.getAnalyticsConsent();
    }

    // Show dialog and wait for response
    final consented = await showDialog<bool>(
      context: context,
      barrierDismissible: false, // User must make a choice
      builder: (_) => const AnalyticsConsentDialog(),
    );

    return consented ?? false;
  }

  Future<void> _handleConsent(BuildContext context, bool consented) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    // Save user's choice for both analytics and crash logs
    final analyticsResult = await sharedPrefs.setAnalyticsConsent(consented);
    final crashResult = await sharedPrefs.setCrashLogsConsent(consented);
    final askedResult = await sharedPrefs.setAnalyticsConsentAsked(true);

    if (!analyticsResult || !crashResult || !askedResult) {
      if (kDebugMode) {
        debugPrint(
          'AnalyticsConsentDialog: Failed to save consent preferences',
        );
      }
    }

    // Initialize services if user consented and save succeeded
    if (consented && analyticsResult && crashResult) {
      await initializePostHogAfterConsent();
      await initializeCrashlyticsAfterConsent();
    }

    if (context.mounted) {
      Navigator.of(context).pop(consented);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      title: const Text('Help Improve GameWatch'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'We use privacy-friendly analytics and crash reporting to improve your experience.',
            ),
            SizedBox(height: context.spacings.m),
            Text(
              'What we collect:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.spacings.xs),
            const _BulletPoint(text: 'Anonymized crash logs'),
            const _BulletPoint(text: 'Which screens you visit'),
            const _BulletPoint(text: 'App version and platform'),
            SizedBox(height: context.spacings.m),
            Text(
              'What we never collect:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: context.spacings.xs),
            const _BulletPoint(text: 'Personal information'),
            const _BulletPoint(text: 'Your game reminders'),
            const _BulletPoint(text: 'Screen recordings'),
            SizedBox(height: context.spacings.m),
            Text(
              'You can change this anytime in Privacy settings.',
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => _handleConsent(context, false),
          child: const Text('No thanks'),
        ),
        FilledButton(
          onPressed: () => _handleConsent(context, true),
          child: const Text('Allow'),
        ),
      ],
    );
  }
}

class _BulletPoint extends StatelessWidget {
  const _BulletPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: context.spacings.xs,
        bottom: context.spacings.xxs,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• '),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
