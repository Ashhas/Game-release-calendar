// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'platform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlatformAdapter extends TypeAdapter<Platform> {
  @override
  final int typeId = 1;

  @override
  Platform read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Platform(
      id: fields[0] as int?,
      abbreviation: fields[1] as String?,
      name: fields[2] as String?,
      url: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Platform obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.abbreviation)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlatformAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
