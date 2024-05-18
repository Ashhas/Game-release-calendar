import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/theme/context_extensions.dart';
import 'package:get_it/get_it.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppDetails extends StatelessWidget {
  const AppDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final appVersion = GetIt.instance.get<PackageInfo>().version;

    return Column(
      children: [
        Center(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: context.spacings.l),
            child: const Icon(
              Icons.emoji_symbols,
              size: 100.0,
            ),
          ),
        ),
        const Text(
          'Version',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Text(
          'v$appVersion',
          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
        ),
      ],
    );
  }
}
