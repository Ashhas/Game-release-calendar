import 'package:flutter/material.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';

class GameCard extends StatelessWidget {
  final GameReminder reminder;

  const GameCard({
    super.key,
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      //color: Color.fromARGB(255, 251, 251, 251),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      //color: Color.fromARGB(255, 255, 255, 255),
                      color: Theme.of(context).colorScheme.surface,
                      width: 6,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      // reminder.gamePayload.artworks != null
                      //     ? reminder.gamePayload.artworks!.first.imageUrl(
                      //         size: 'screenshot_med',
                      //       )
                      //     : reminder.gamePayload.cover!.imageUrl(
                      //         size: 'screenshot_big',
                      //       ),
                      reminder.gamePayload.cover!.imageUrl(
                        size: 'cover_big',
                      ),
                      //height: 180,
                      height: double.infinity,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 255, 255, 255),
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      reminder.releaseDate.platform!.abbreviation.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 4,
                  left: 4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      //color: Color.fromARGB(255, 255, 255, 255),
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      reminder.releaseDate.human.toString(),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
              left: 12,
              right: 12,
              top: 6,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    reminder.gameName,
                    style: Theme.of(context).textTheme.titleSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
