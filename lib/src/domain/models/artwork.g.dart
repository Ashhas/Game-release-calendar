// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ArtworkAdapter extends TypeAdapter<Artwork> {
  @override
  final int typeId = 7;

  @override
  Artwork read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Artwork(
      id: fields[0] as int,
      imageId: fields[1] as String,
      url: fields[2] as String,
      game: fields[7] as int,
      alphaChannel: fields[3] as bool?,
      animated: fields[4] as bool?,
      checksum: fields[8] as String?,
      width: fields[5] as int?,
      height: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Artwork obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.imageId)
      ..writeByte(2)
      ..write(obj.url)
      ..writeByte(3)
      ..write(obj.alphaChannel)
      ..writeByte(4)
      ..write(obj.animated)
      ..writeByte(5)
      ..write(obj.width)
      ..writeByte(6)
      ..write(obj.height)
      ..writeByte(7)
      ..write(obj.game)
      ..writeByte(8)
      ..write(obj.checksum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ArtworkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
