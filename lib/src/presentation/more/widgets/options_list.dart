part of '../more_container.dart';

class OptionsList extends StatelessWidget {
  const OptionsList({super.key});

  static const _supportEmail = 'ashhas.studio@gmail.com';

  @override
  Widget build(BuildContext context) {
    final appVersion = GetIt.instance.get<PackageInfo>().version;

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.notifications_none_outlined),
          title: const Text('Notification Settings'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Notifications()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.color_lens_outlined),
          title: const Text('Theme'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AppTheme()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.visibility_outlined),
          title: const Text('Content Preferences'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ContentPreferences()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.shield_outlined),
          title: const Text('Privacy'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const Privacy()),
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
          leading: const Icon(Icons.support_agent),
          title: const Text('Support'),
          onTap: () => _handleSupportTap(context),
        ),
      ],
    );
  }

  Future<void> _handleSupportTap(BuildContext context) async {
    final appVersion = GetIt.instance.get<PackageInfo>().version;
    final emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _supportEmail,
      queryParameters: {'subject': '[GameWatch v$appVersion] Support Request'},
    );

    final launched = await UrlHelper.launchUri(emailLaunchUri);

    if (!launched && context.mounted) {
      // No email app available - copy email to clipboard and show message
      await Clipboard.setData(ClipboardData(text: _supportEmail));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Email copied: $_supportEmail'),
            action: SnackBarAction(label: 'OK', onPressed: () {}),
          ),
        );
      }
    }
  }
}
