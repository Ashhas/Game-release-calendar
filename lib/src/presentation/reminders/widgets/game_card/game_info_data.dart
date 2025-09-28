import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';

import 'game_card.dart';

class GameInfoData extends StatelessWidget {
  const GameInfoData({
    super.key,
    required this.reminder,
    required this.label,
    required this.description,
  });

  final String label;
  final String description;
  final GameReminder reminder;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reminder.releaseDate.platform != null)
            PlatformChip(
              platformAbbreviation:
                  reminder.releaseDate.platform!.abbreviation.toString(),
            ),
          SizedBox(height: context.spacings.xxs),
          Text(
            description,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
