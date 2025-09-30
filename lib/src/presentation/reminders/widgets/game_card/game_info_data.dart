import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';

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
    // Check if the game has been released (date is in the past)
    final bool isReleased = reminder.releaseDate.date != null &&
        DateTime.fromMillisecondsSinceEpoch(reminder.releaseDate.date! * 1000).isBefore(DateTime.now());

    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            isReleased ? 'Released' : label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isReleased ? Theme.of(context).colorScheme.primary : Colors.white,
                ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    );
  }
}
