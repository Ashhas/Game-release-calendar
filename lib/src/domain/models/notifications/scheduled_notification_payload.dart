import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

part 'scheduled_notification_payload.g.dart';

@HiveType(typeId: 5)
class ScheduledNotificationPayload {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int gameId;

  @HiveField(2)
  final String gameName;

  @HiveField(3)
  final Game game;

  @HiveField(4)
  final TZDateTime scheduledDateTime;

  @HiveField(5)
  final ReleaseDateCategory releaseDateCategory;

  const ScheduledNotificationPayload({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.game,
    required this.scheduledDateTime,
    required this.releaseDateCategory,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'gameName': gameName,
      'game': game.toJson(),
      'scheduledDateTime': {
        'millisecondsSinceEpoch': scheduledDateTime.millisecondsSinceEpoch,
        'location': scheduledDateTime.location.name,
      },
      'releaseDateCategory': releaseDateCategory.toValue(),
    };
  }

  factory ScheduledNotificationPayload.fromJson(Map<String, dynamic> json) {
    return ScheduledNotificationPayload(
      id: json['id'],
      gameId: json['gameId'],
      gameName: json['gameName'],
      game: Game.fromJson(json['game']),
      scheduledDateTime: TZDateTime.fromMillisecondsSinceEpoch(
        getLocation(json['scheduledDateTime']['location']),
        json['scheduledDateTime']['millisecondsSinceEpoch'],
      ),
      releaseDateCategory:
          ReleaseDateCategory.fromValue(json['releaseDateCategory']),
    );
  }

  /// Creates a ScheduledNotification instance from a Game object.
  factory ScheduledNotificationPayload.fromGame({
    required Game game,
    required TZDateTime scheduledReleaseDate,
    required ReleaseDateCategory releaseDateCategory,
  }) {
    return ScheduledNotificationPayload(
      id: game.id,
      gameId: game.id,
      gameName: game.name,
      game: game,
      scheduledDateTime: scheduledReleaseDate,
      releaseDateCategory: releaseDateCategory,
    );
  }
}
