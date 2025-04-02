import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

part 'game_reminder.g.dart';

@HiveType(typeId: 6)
class GameReminder {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int gameId;

  @HiveField(2)
  final String gameName;

  @HiveField(3)
  final Game gamePayload;

  @HiveField(4)
  final ReleaseDate releaseDate;

  @HiveField(5)
  final ReleaseDateCategory releaseDateCategory;

  @HiveField(6)
  final DateTime? notificationDate;

  const GameReminder({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.gamePayload,
    required this.releaseDate,
    required this.releaseDateCategory,
    required this.notificationDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'gameId': gameId,
      'gameName': gameName,
      'game': gamePayload.toJson(),
      'releaseDate': releaseDate.toJson(),
      'releaseDateCategory': releaseDateCategory.toValue(),
      'notificationDate': notificationDate?.toIso8601String(),
    };
  }

  factory GameReminder.fromJson(Map<String, dynamic> json) {
    return GameReminder(
      id: json['id'],
      gameId: json['gameId'],
      gameName: json['gameName'],
      gamePayload: Game.fromJson(json['game']),
      releaseDate: ReleaseDate.fromJson(json['releaseDate']),
      releaseDateCategory:
          ReleaseDateCategory.fromValue(json['releaseDateCategory']),
      notificationDate: DateTime.parse(json['notificationDate']),
    );
  }

  /// Creates a ScheduledNotification instance from a Game object.
  factory GameReminder.fromGame({
    required Game game,
    required ReleaseDate releaseDate,
    required ReleaseDateCategory releaseDateCategory,
    required DateTime? notificationDate,
  }) {
    return GameReminder(
      id: releaseDate.id,
      gameId: game.id,
      gameName: game.name,
      gamePayload: game,
      releaseDate: releaseDate,
      releaseDateCategory: releaseDateCategory,
      notificationDate: notificationDate,
    );
  }
}
