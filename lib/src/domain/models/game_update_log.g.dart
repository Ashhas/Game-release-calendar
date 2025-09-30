// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_update_log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameUpdateLogAdapter extends TypeAdapter<GameUpdateLog> {
  @override
  final int typeId = 13;

  @override
  GameUpdateLog read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameUpdateLog(
      id: fields[0] as String,
      gameId: fields[1] as int,
      gameName: fields[2] as String,
      gamePayload: fields[3] as Game,
      updateType: fields[4] as GameUpdateType,
      detectedAt: fields[5] as DateTime,
      oldValue: fields[6] as String?,
      newValue: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, GameUpdateLog obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameId)
      ..writeByte(2)
      ..write(obj.gameName)
      ..writeByte(3)
      ..write(obj.gamePayload)
      ..writeByte(4)
      ..write(obj.updateType)
      ..writeByte(5)
      ..write(obj.detectedAt)
      ..writeByte(6)
      ..write(obj.oldValue)
      ..writeByte(7)
      ..write(obj.newValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameUpdateLogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
