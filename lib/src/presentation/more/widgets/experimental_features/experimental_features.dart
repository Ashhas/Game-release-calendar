part of '../../more_container.dart';

class ExperimentalFeatures extends StatefulWidget {
  const ExperimentalFeatures({super.key});

  @override
  State<ExperimentalFeatures> createState() => _ExperimentalFeaturesState();
}

class _ExperimentalFeaturesState extends State<ExperimentalFeatures> {
  late SharedPrefsService _sharedPrefs;
  bool _scrollbarEnabled = false;

  @override
  void initState() {
    super.initState();
    _sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    _loadSettings();
  }

  void _loadSettings() {
    setState(() {
      _scrollbarEnabled = _sharedPrefs.getScrollbarEnabled();
    });
  }

  Future<void> _setScrollbarEnabled(bool enabled) async {
    await _sharedPrefs.setScrollbarEnabled(enabled);
    setState(() {
      _scrollbarEnabled = enabled;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            enabled ? 'Date scrollbar enabled' : 'Date scrollbar disabled'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Experimental Features'),
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: Padding(
        padding: EdgeInsets.all(context.spacings.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(context.spacings.m),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  SizedBox(width: context.spacings.s),
                  Expanded(
                    child: Text(
                      'These features are experimental and may be unstable. Use at your own risk.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: context.spacings.l),
            Card(
              child: SwitchListTile(
                title: const Text('Date Scrollbar'),
                subtitle: const Text(
                    'Enable vertical scrollbar with snap-to-date functionality'),
                secondary: const Icon(Icons.linear_scale),
                value: _scrollbarEnabled,
                onChanged: _setScrollbarEnabled,
              ),
            ),
            SizedBox(height: context.spacings.m),
            Text(
              'About Experimental Features',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: context.spacings.s),
            Text(
              'Experimental features are new capabilities that are still in development. '
              'They may have bugs, performance issues, or be removed in future updates. '
              'Enable them only if you want to test cutting-edge functionality.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
