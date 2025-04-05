import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import '../../../../utils/constants.dart';

part 'platform_chip.dart';

part 'game_date_chip.dart';

part 'game_cover_art.dart';

part 'bottom_card.dart';

class GameCard extends StatelessWidget {
  final GameReminder reminder;
  final bool isVertical;

  const GameCard({
    super.key,
    required this.reminder,
    this.isVertical = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Color.fromARGB(255, 255, 255, 255),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: Stack(
              children: [
                GameCoverArt(
                  imageUrl: reminder.gamePayload.cover?.imageUrl(
                        size: 'cover_big',
                      ) ??
                      Constants.placeholderImageUrl,
                  isVertical: isVertical,
                ),
                PlatformChip(
                  platformAbbreviation:
                      reminder.releaseDate.platform!.abbreviation.toString(),
                ),
                GameDateChip(
                  label: reminder.releaseDate.human.toString(),
                ),
              ],
            ),
          ),
          BottomCard(
            description: reminder.gameName,
          ),
        ],
      ),
    );
  }
}
