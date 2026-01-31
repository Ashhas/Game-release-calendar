part of '../../more_container.dart';

class ContentPreferences extends StatefulWidget {
  const ContentPreferences({super.key});

  @override
  State<ContentPreferences> createState() => _ContentPreferencesState();
}

class _ContentPreferencesState extends State<ContentPreferences> {
  late bool _showEroticContentDefault;
  late DateFilterChoice _releaseDateTypeDefault;
  ReleasePrecisionFilter? _releasePrecisionDefault;

  static const _dateFilterLabels = {
    DateFilterChoice.allTime: 'All Time',
    DateFilterChoice.thisWeek: 'This Week',
    DateFilterChoice.thisMonth: 'This Month',
    DateFilterChoice.nextMonth: 'Next Month',
    DateFilterChoice.next3Months: 'Next 3 Months',
  };

  @override
  void initState() {
    super.initState();
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    _showEroticContentDefault = sharedPrefs.getShowEroticContentDefault();
    _releaseDateTypeDefault = sharedPrefs.getReleaseDateTypeDefault();
    _releasePrecisionDefault = sharedPrefs.getReleasePrecisionDefault();

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

  Future<void> _setReleaseDateType(DateFilterChoice choice) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    final saved = await sharedPrefs.setReleaseDateTypeDefault(choice);

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
      _releaseDateTypeDefault = choice;
    });
  }

  Future<void> _setReleasePrecision(ReleasePrecisionFilter? choice) async {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();

    final saved = await sharedPrefs.setReleasePrecisionDefault(choice);

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
      _releasePrecisionDefault = choice;
    });
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
          _SectionHeader(title: 'Release Date Range'),
          ...DateFilterChoice.values.map(
            (choice) => RadioListTile<DateFilterChoice>(
              title: Text(_dateFilterLabels[choice] ?? choice.name),
              value: choice,
              groupValue: _releaseDateTypeDefault,
              onChanged: (value) {
                if (value != null) _setReleaseDateType(value);
              },
            ),
          ),
          SizedBox(height: context.spacings.m),
          const _InfoCard(
            text:
                'This sets the default date range filter when browsing games. '
                'You can change this temporarily from the filter menu.',
          ),
          SizedBox(height: context.spacings.l),
          _SectionHeader(title: 'Release Date Type'),
          RadioListTile<ReleasePrecisionFilter?>(
            title: const Text('All Release Types'),
            subtitle: const Text('Include games with TBD dates'),
            value: null,
            groupValue: _releasePrecisionDefault,
            onChanged: (value) => _setReleasePrecision(value),
          ),
          RadioListTile<ReleasePrecisionFilter?>(
            title: const Text('Exact Dates Only'),
            subtitle: const Text('Only show games with confirmed dates'),
            value: ReleasePrecisionFilter.exactDate,
            groupValue: _releasePrecisionDefault,
            onChanged: (value) => _setReleasePrecision(value),
          ),
          SizedBox(height: context.spacings.m),
          const _InfoCard(
            text:
                'This filters games by how precise their release date is. '
                '"Exact Dates Only" hides games that only have a year, quarter, or TBD.',
          ),
          SizedBox(height: context.spacings.l),
          _SectionHeader(title: 'Content Visibility'),
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
                'Violence, horror, and other mature content is not affected by this setting.',
          ),
        ],
      ),
    );
  }
}
