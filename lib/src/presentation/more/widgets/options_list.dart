part of '../more_container.dart';

class OptionsList extends StatelessWidget {
  const OptionsList({super.key});

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
      ],
    );
  }
}
