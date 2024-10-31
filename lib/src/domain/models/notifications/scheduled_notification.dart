import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:hive/hive.dart';
import 'package:timezone/timezone.dart';

part 'scheduled_notification.g.dart';

@HiveType(typeId: 5) // Ensure the typeId is unique
class ScheduledNotification {
  @HiveField(0)
  final int id; // Notification ID

  @HiveField(1)
  final int gameId;

  @HiveField(2)
  final String gameName;

  @HiveField(3)
  final Game game;

  @HiveField(4)
  final TZDateTime scheduledDateTime;

  ScheduledNotification({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.game,
    required this.scheduledDateTime,
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
    };
  }

  factory ScheduledNotification.fromJson(Map<String, dynamic> json) {
    return ScheduledNotification(
      id: json['id'],
      gameId: json['gameId'],
      gameName: json['gameName'],
      game: Game.fromJson(json['game']),
      scheduledDateTime: TZDateTime.fromMillisecondsSinceEpoch(
        getLocation(json['scheduledDateTime']['location']),
        json['scheduledDateTime']['millisecondsSinceEpoch'],
      ),
    );
  }

  /// Creates a ScheduledNotification instance from a Game object.
  factory ScheduledNotification.fromGame({
    required Game game,
    required TZDateTime scheduledReleaseDate,
  }) {
    return ScheduledNotification(
      id: game.id,
      gameId: game.id,
      gameName: game.name,
      game: game,
      scheduledDateTime: scheduledReleaseDate,
    );
  }
}
