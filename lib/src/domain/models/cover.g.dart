// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cover.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CoverAdapter extends TypeAdapter<Cover> {
  @override
  final int typeId = 2;

  @override
  Cover read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Cover(
      id: fields[0] as int?,
      url: fields[1] as String?,
      imageId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Cover obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.imageId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CoverAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
