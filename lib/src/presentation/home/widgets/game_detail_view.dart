import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

import 'package:url_launcher/url_launcher.dart';

class GameDetailView extends StatefulWidget {
  final Game game;

  const GameDetailView({
    required this.game,
    super.key,
  });

  @override
  State<GameDetailView> createState() => _GameDetailViewState();
}

class _GameDetailViewState extends State<GameDetailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.game.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.web),
            onPressed: () => _launchUrl(),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    final Uri url = Uri.parse(widget.game.url);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
