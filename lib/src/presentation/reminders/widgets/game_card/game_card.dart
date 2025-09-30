import 'package:flutter/material.dart';

import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/game_image.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_info_data.dart';
import 'package:game_release_calendar/src/theme/theme_extensions.dart';
import '../../../../utils/constants.dart';

part 'platform_chip.dart';

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

    // Check if the game has been released
    final bool isReleased = reminder.releaseDate.date != null &&
        DateTime.fromMillisecondsSinceEpoch(reminder.releaseDate.date! * 1000).isBefore(DateTime.now());

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(context.spacings.s))),
      color: cardColor, // Explicitly set the card color
      child: Stack(
        fit: StackFit.expand,
        children: [
          GameCoverArt(
            imageUrl: reminder.gamePayload.cover?.imageUrl(
                  size: 'cover_big',
                ) ??
                Constants.placeholderImageUrl,
            isVertical: isVertical,
          ),
          // Simple dark gradient overlay at bottom for text readability
          if (!isReleased)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 40,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(context.spacings.s),
                    bottomRight: Radius.circular(context.spacings.s),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.9),
                      Colors.transparent,
                    ],
                    stops: const [0.3, 1.0],
                  ),
                ),
              ),
            ),
          // Full dark overlay for released games
          if (isReleased)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
          // Platform chip positioned above the black background
          if (!isReleased && reminder.releaseDate.platform != null)
            Positioned(
              bottom: 50, // Above the black background
              left: context.spacings.xxs,
              child: PlatformChip(
                platformAbbreviation:
                    reminder.releaseDate.platform!.abbreviation.toString(),
              ),
            ),
          Positioned(
            bottom: context.spacings.xs,
            left: context.spacings.xxs,
            right: context.spacings.xs,
            child: GameInfoData(
              label: reminder.releaseDate.human ?? 'TBD',
              description: reminder.gameName,
              reminder: reminder,
            ),
          ),
          if (onRemove != null)
            Positioned(
              // top: context.spacings.xxs,
              // right: context.spacings.xxs,
              top: 0,
              right: 0,
              child: DeleteChip(
                onRemove: onRemove,
              ),
            ),
        ],
      ),
    );
  }
}
