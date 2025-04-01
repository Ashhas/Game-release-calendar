// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_notification_payload.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledNotificationPayloadAdapter
    extends TypeAdapter<ScheduledNotificationPayload> {
  @override
  final int typeId = 5;

  @override
  ScheduledNotificationPayload read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledNotificationPayload(
      id: fields[0] as int,
      gameId: fields[1] as int,
      gameName: fields[2] as String,
      game: fields[3] as Game,
      scheduledDateTime: fields[4] as TZDateTime,
      releaseDateCategory: fields[5] as ReleaseDateCategory,
      releaseDate: fields[6] as ReleaseDate,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledNotificationPayload obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameId)
      ..writeByte(2)
      ..write(obj.gameName)
      ..writeByte(3)
      ..write(obj.game)
      ..writeByte(4)
      ..write(obj.scheduledDateTime)
      ..writeByte(5)
      ..write(obj.releaseDateCategory)
      ..writeByte(6)
      ..write(obj.releaseDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotificationPayloadAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
