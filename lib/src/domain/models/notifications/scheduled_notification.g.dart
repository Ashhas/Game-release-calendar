// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_notification.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledNotificationAdapter extends TypeAdapter<ScheduledNotification> {
  @override
  final int typeId = 5;

  @override
  ScheduledNotification read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledNotification(
      id: fields[0] as int,
      gameId: fields[1] as int,
      gameName: fields[2] as String,
      game: fields[3] as Game,
      scheduledDateTime: fields[4] as TZDateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledNotification obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.gameId)
      ..writeByte(2)
      ..write(obj.gameName)
      ..writeByte(3)
      ..write(obj.game)
      ..writeByte(4)
      ..write(obj.scheduledDateTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledNotificationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
