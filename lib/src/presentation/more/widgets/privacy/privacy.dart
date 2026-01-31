part of '../../more_container.dart';

class Privacy extends StatefulWidget {
  const Privacy({super.key});

  @override
  State<Privacy> createState() => _PrivacyState();
}

class _PrivacyState extends State<Privacy> {
  late bool _analyticsEnabled;
  late bool _crashLogsEnabled;

  @override
  void initState() {
    super.initState();
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    _analyticsEnabled = sharedPrefs.getAnalyticsConsent();
    _crashLogsEnabled = sharedPrefs.getCrashLogsConsent();

    // Only track if analytics is enabled
    if (_analyticsEnabled) {
      GetIt.instance.get<AnalyticsService>().trackScreenViewed(
        screenName: 'Privacy',
      );
    }
  }

  Future<void> _toggleAnalytics(bool enabled) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    final consentSaved = await sharedPrefs.setAnalyticsConsent(enabled);
    final askedSaved = await sharedPrefs.setAnalyticsConsentAsked(true);

    if (!consentSaved || !askedSaved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preference. Please try again.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _analyticsEnabled = enabled;
    });

    if (enabled) {
      await initializePostHogAfterConsent();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Analytics enabled. Thank you for helping improve the app!'
                : 'Analytics disabled. No data will be collected.',
          ),
        ),
      );
    }
  }

  Future<void> _toggleCrashLogs(bool enabled) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    final consentSaved = await sharedPrefs.setCrashLogsConsent(enabled);

    if (!consentSaved) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to save preference. Please try again.'),
          ),
        );
      }
      return;
    }

    setState(() {
      _crashLogsEnabled = enabled;
    });

    if (enabled) {
      await initializeCrashlyticsAfterConsent();
    } else {
      await disableCrashlytics();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Crash logs enabled. This helps us fix issues faster!'
                : 'Crash logs disabled.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Privacy',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: ListView(
        children: [
          // Privacy Policy section
          _SectionHeader(title: 'Privacy Policy'),
          ListTile(
            leading: const Icon(Icons.description_outlined),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PrivacyPolicy(),
                ),
              );
            },
          ),
          SizedBox(height: context.spacings.m),
          // Analytics and Crash logs section
          _SectionHeader(title: 'Analytics and Crash logs'),
          SwitchListTile(
            title: const Text('Send crash logs'),
            subtitle: const Text('Send anonymized crash logs to the developers.'),
            value: _crashLogsEnabled,
            onChanged: _toggleCrashLogs,
          ),
          SwitchListTile(
            title: const Text('Allow analytics'),
            subtitle: const Text('Send anonymized usage data to improve app features.'),
            value: _analyticsEnabled,
            onChanged: _toggleAnalytics,
          ),
          SizedBox(height: context.spacings.m),
          const _InfoCard(
            text:
                'Sending crash logs and analytics will allow us to identify and fix issues, improve performance, and make future updates more relevant to your needs.',
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.only(
        left: context.spacings.m,
        top: context.spacings.m,
        bottom: context.spacings.xs,
      ),
      child: Text(
        title,
        style: TextStyle(
          color: colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.spacings.m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 20,
            color: colorScheme.onSurfaceVariant,
          ),
          SizedBox(width: context.spacings.xs),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
