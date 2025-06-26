part of '../more_container.dart';

class OptionsList extends StatefulWidget {
  const OptionsList({super.key});

  @override
  State<OptionsList> createState() => _OptionsListState();
}

class _OptionsListState extends State<OptionsList> {
  int _tapCount = 0;
  bool _showExperimentalFeatures = false;

  @override
  void initState() {
    super.initState();
    _loadExperimentalFeaturesVisibility();
  }

  void _loadExperimentalFeaturesVisibility() {
    final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
    setState(() {
      _showExperimentalFeatures = sharedPrefs.getExperimentalFeaturesEnabled();
    });
  }

  void _handleVersionTap() {
    setState(() {
      _tapCount++;
    });

    if (_tapCount >= 5) {
      final sharedPrefs = GetIt.instance.get<SharedPrefsService>();
      sharedPrefs.setExperimentalFeaturesEnabled(true);
      setState(() {
        _showExperimentalFeatures = true;
        _tapCount = 0;
      });
      
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
    final appVersion = GetIt.instance.get<PackageInfo>().version;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_none_outlined),
          title: const Text('Notifications'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => Notifications(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: const Text('Theme'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AppTheme(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.description_outlined),
          title: const Text('Privacy Policy'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const PrivacyPolicy(),
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('Open-source licenses'),
          onTap: () {
            showLicensePage(
              context: context,
              applicationName: 'Game Release Calendar',
              applicationVersion: 'Version $appVersion',
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.mail_outline),
          title: const Text('Support'),
          onTap: () {
            final emailLaunchUri = Uri(
              scheme: 'mailto',
              path: 'ashhas.studio@gmail.com',
              queryParameters: {
                'subject': 'GameWatch\tSupport',
              },
            );
            UrlHelper.launchUri(emailLaunchUri);
          },
        ),
        if (_showExperimentalFeatures)
          ListTile(
            leading: const Icon(Icons.science_outlined),
            title: const Text('Experimental Features'),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ExperimentalFeatures(),
                ),
              );
              _loadExperimentalFeaturesVisibility();
            },
          ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: Text('Version $appVersion'),
          onTap: _handleVersionTap,
        ),
      ],
    );
  }
}
