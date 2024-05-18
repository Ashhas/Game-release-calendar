import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/presentation/settings/widgets/privacy_policy.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

class OptionsList extends StatelessWidget {
  const OptionsList({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion = GetIt.instance.get<PackageInfo>().version;

    return Column(
      children: [
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
          leading: const Icon(Icons.info_outline),
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
      ],
    );
  }
}
