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
    final cardColor = Theme.of(context).colorScheme.surfaceContainerLow;
    final bool isReleased = reminder.releaseDate.isReleasedWithExactDate;

    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(context.spacings.s))),
      color: cardColor,
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
          if (isReleased)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(context.spacings.s)),
                  color: Colors.black.withValues(alpha: 0.7),
                ),
              ),
            ),
          if (!isReleased && reminder.releaseDate.platform != null)
            Positioned(
              bottom: 50,
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
