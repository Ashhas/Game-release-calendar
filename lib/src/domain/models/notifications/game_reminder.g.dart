// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_reminder.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameReminderAdapter extends TypeAdapter<GameReminder> {
  @override
  final typeId = 6;

  @override
  GameReminder read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameReminder(
      id: (fields[0] as num).toInt(),
      gameId: (fields[1] as num).toInt(),
      gameName: fields[2] as String,
      gamePayload: fields[3] as Game,
      releaseDate: fields[4] as ReleaseDate,
      releaseDateCategory: fields[5] as ReleaseDateCategory,
      notificationDate: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, GameReminder obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameId)
      ..writeByte(2)
      ..write(obj.gameName)
      ..writeByte(3)
      ..write(obj.gamePayload)
      ..writeByte(4)
      ..write(obj.releaseDate)
      ..writeByte(5)
      ..write(obj.releaseDateCategory)
      ..writeByte(6)
      ..write(obj.notificationDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameReminderAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
