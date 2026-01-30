// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_date_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReleaseDateCategoryAdapter extends TypeAdapter<ReleaseDateCategory> {
  @override
  final typeId = 4;

  @override
  ReleaseDateCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReleaseDateCategory.exactDate;
      case 1:
        return ReleaseDateCategory.yearMonth;
      case 2:
        return ReleaseDateCategory.quarter;
      case 3:
        return ReleaseDateCategory.year;
      case 4:
        return ReleaseDateCategory.tbd;
      default:
        return ReleaseDateCategory.exactDate;
    }
  }

  @override
  void write(BinaryWriter writer, ReleaseDateCategory obj) {
    switch (obj) {
      case ReleaseDateCategory.exactDate:
        writer.writeByte(0);
      case ReleaseDateCategory.yearMonth:
        writer.writeByte(1);
      case ReleaseDateCategory.quarter:
        writer.writeByte(2);
      case ReleaseDateCategory.year:
        writer.writeByte(3);
      case ReleaseDateCategory.tbd:
        writer.writeByte(4);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReleaseDateCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
