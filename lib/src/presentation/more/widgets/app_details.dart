part of '../more_container.dart';

class AppDetails extends StatefulWidget {
  const AppDetails({super.key, this.onExperimentalUnlocked});

  final VoidCallback? onExperimentalUnlocked;

  @override
  State<AppDetails> createState() => _AppDetailsState();
}

class _AppDetailsState extends State<AppDetails> {
  int _tapCount = 0;

  void _handleIconTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount >= 5) {
      final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
      sharedPrefs.setExperimentalFeaturesEnabled(true);
      setState(() {
        _tapCount = 0;
      });

      widget.onExperimentalUnlocked?.call();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Experimental features unlocked!'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _tapCount = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final appInfo = GetIt.instance.get<PackageInfo>();

    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.spacings.l),
            child: GestureDetector(
              onTap: _handleIconTap,
              child: const Icon(
                Icons.emoji_symbols,
                size: 100.0,
              ),
            ),
          ),
        ),
        Text(
          '${appInfo.appName}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          'v${appInfo.version}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}
