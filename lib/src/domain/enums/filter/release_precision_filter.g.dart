// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_precision_filter.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReleasePrecisionFilterAdapter
    extends TypeAdapter<ReleasePrecisionFilter> {
  @override
  final int typeId = 15;

  @override
  ReleasePrecisionFilter read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReleasePrecisionFilter.all;
      case 1:
        return ReleasePrecisionFilter.exactDate;
      case 2:
        return ReleasePrecisionFilter.yearMonth;
      case 3:
        return ReleasePrecisionFilter.quarter;
      case 4:
        return ReleasePrecisionFilter.yearOnly;
      case 5:
        return ReleasePrecisionFilter.tbd;
      default:
        return ReleasePrecisionFilter.all;
    }
  }

  @override
  void write(BinaryWriter writer, ReleasePrecisionFilter obj) {
    switch (obj) {
      case ReleasePrecisionFilter.all:
        writer.writeByte(0);
        break;
      case ReleasePrecisionFilter.exactDate:
        writer.writeByte(1);
        break;
      case ReleasePrecisionFilter.yearMonth:
        writer.writeByte(2);
        break;
      case ReleasePrecisionFilter.quarter:
        writer.writeByte(3);
        break;
      case ReleasePrecisionFilter.yearOnly:
        writer.writeByte(4);
        break;
      case ReleasePrecisionFilter.tbd:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReleasePrecisionFilterAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
