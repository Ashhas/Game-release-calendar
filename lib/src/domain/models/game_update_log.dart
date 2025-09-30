import 'package:hive/hive.dart';

import 'package:game_release_calendar/src/domain/enums/game_update_type.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';

part 'game_update_log.g.dart';

@HiveType(typeId: 13)
class GameUpdateLog {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int gameId;

  @HiveField(2)
  final String gameName;

  @HiveField(3)
  final Game gamePayload;

  @HiveField(4)
  final GameUpdateType updateType;

  @HiveField(5)
  final DateTime detectedAt;

  @HiveField(6)
  final String? oldValue;

  @HiveField(7)
  final String? newValue;

  const GameUpdateLog({
    required this.id,
    required this.gameId,
    required this.gameName,
    required this.gamePayload,
    required this.updateType,
    required this.detectedAt,
    this.oldValue,
    this.newValue,
  });

  factory GameUpdateLog.create({
    required int gameId,
    required String gameName,
    required Game gamePayload,
    required GameUpdateType updateType,
    String? oldValue,
    String? newValue,
  }) {
    final now = DateTime.now();
    final id = '${gameId}_${updateType.name}_${now.millisecondsSinceEpoch}';

    return GameUpdateLog(
      id: id,
      gameId: gameId,
      gameName: gameName,
      gamePayload: gamePayload,
      updateType: updateType,
      detectedAt: now,
      oldValue: oldValue,
      newValue: newValue,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameUpdateLog && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return '''GameUpdateLog(
      id: $id,
      gameId: $gameId,
      gameName: $gameName,
      updateType: $updateType,
      detectedAt: $detectedAt,
      oldValue: $oldValue,
      newValue: $newValue
    )''';
  }
}