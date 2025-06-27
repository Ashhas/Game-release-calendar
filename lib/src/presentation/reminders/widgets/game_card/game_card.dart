import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_image.dart';
import '../../../../utils/constants.dart';

part 'platform_chip.dart';

part 'game_date_chip.dart';

part 'game_cover_art.dart';

part 'bottom_card.dart';

part 'delete_chip.dart';

class GameCard extends StatelessWidget {
  final GameReminder reminder;
  final bool isVertical;
  final VoidCallback? onRemove;

  const GameCard({
    super.key,
    required this.reminder,
    this.isVertical = false,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    // Explicitly define the card color we want to use
    final cardColor = Theme.of(context).colorScheme.surfaceContainerLow;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: cardColor, // Explicitly set the card color
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
                if (onRemove != null)
                  DeleteChip(
                    onRemove: onRemove,
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
