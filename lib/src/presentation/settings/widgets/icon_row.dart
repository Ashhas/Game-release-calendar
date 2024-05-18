import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class IconRow extends StatelessWidget {
  const IconRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            IconButton(
              icon: const Icon(Icons.mail),
              onPressed: _openMailApp,
            ),
            const Text('Questions? Email us!'),
          ],
        ),
      ],
    );
  }

  void _openMailApp() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ashhas.studio@gmail.com',
      queryParameters: {
        'subject': 'GameWatch\tSupport',
      },
    );
    launchUrl(emailLaunchUri);
  }
}
