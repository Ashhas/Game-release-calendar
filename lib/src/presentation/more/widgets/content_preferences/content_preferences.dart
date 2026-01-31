part of '../../more_container.dart';

class ContentPreferences extends StatefulWidget {
  const ContentPreferences({super.key});

  @override
  State<ContentPreferences> createState() => _ContentPreferencesState();
}

class _ContentPreferencesState extends State<ContentPreferences> {
  late bool _showEroticContentDefault;

  @override
  void initState() {
    super.initState();
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    _showEroticContentDefault = sharedPrefs.getShowEroticContentDefault();

    // Track screen view if analytics is enabled
    if (sharedPrefs.getAnalyticsConsent()) {
      GetIt.instance.get<AnalyticsService>().trackScreenViewed(
        screenName: 'ContentPreferences',
      );
    }
  }

  Future<void> _toggleShowEroticContent(bool enabled) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    final saved = await sharedPrefs.setShowEroticContentDefault(enabled);

    if (!saved) {
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
      _showEroticContentDefault = enabled;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enabled
                ? 'Adult content will be shown by default.'
                : 'Adult content will be hidden by default.',
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
          'Content Preferences',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      backgroundColor: colorScheme.surface,
      body: ListView(
        children: [
          _SectionHeader(title: 'Adult Content'),
          SwitchListTile(
            title: const Text('Show adult content by default'),
            subtitle: const Text(
              'Include games with erotic themes in search results.',
            ),
            value: _showEroticContentDefault,
            onChanged: _toggleShowEroticContent,
          ),
          SizedBox(height: context.spacings.m),
          const _InfoCard(
            text:
                'This setting filters games tagged with erotic or sexually explicit themes. '
                'Violence, horror, and other mature content is not affected by this setting. '
                'You can also toggle this filter temporarily from the filter menu on the home screen.',
          ),
        ],
      ),
    );
  }
}
