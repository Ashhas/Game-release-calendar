// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_date.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReleaseDateAdapter extends TypeAdapter<ReleaseDate> {
  @override
  final typeId = 3;

  @override
  ReleaseDate read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReleaseDate(
      id: (fields[0] as num).toInt(),
      date: (fields[1] as num?)?.toInt(),
      human: fields[2] as String?,
      category: fields[3] as ReleaseDateCategory?,
      year: (fields[4] as num?)?.toInt(),
      month: (fields[5] as num?)?.toInt(),
      quarter: (fields[6] as num?)?.toInt(),
      platform: fields[7] as SupportedGamePlatform?,
      region: fields[8] as ReleaseRegion?,
      dateFormat: (fields[9] as num?)?.toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, ReleaseDate obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.human)
      ..writeByte(3)
      ..write(obj.category)
      ..writeByte(4)
      ..write(obj.year)
      ..writeByte(5)
      ..write(obj.month)
      ..writeByte(6)
      ..write(obj.quarter)
      ..writeByte(7)
      ..write(obj.platform)
      ..writeByte(8)
      ..write(obj.region)
      ..writeByte(9)
      ..write(obj.dateFormat);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReleaseDateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
