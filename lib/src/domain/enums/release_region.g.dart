// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_region.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReleaseRegionAdapter extends TypeAdapter<ReleaseRegion> {
  @override
  final typeId = 9;

  @override
  ReleaseRegion read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ReleaseRegion.europe;
      case 1:
        return ReleaseRegion.northAmerica;
      case 2:
        return ReleaseRegion.australia;
      case 3:
        return ReleaseRegion.newZealand;
      case 4:
        return ReleaseRegion.japan;
      case 5:
        return ReleaseRegion.china;
      case 6:
        return ReleaseRegion.asia;
      case 7:
        return ReleaseRegion.worldwide;
      case 8:
        return ReleaseRegion.korea;
      case 9:
        return ReleaseRegion.brazil;
      case 10:
        return ReleaseRegion.unknown;
      default:
        return ReleaseRegion.europe;
    }
  }

  @override
  void write(BinaryWriter writer, ReleaseRegion obj) {
    switch (obj) {
      case ReleaseRegion.europe:
        writer.writeByte(0);
      case ReleaseRegion.northAmerica:
        writer.writeByte(1);
      case ReleaseRegion.australia:
        writer.writeByte(2);
      case ReleaseRegion.newZealand:
        writer.writeByte(3);
      case ReleaseRegion.japan:
        writer.writeByte(4);
      case ReleaseRegion.china:
        writer.writeByte(5);
      case ReleaseRegion.asia:
        writer.writeByte(6);
      case ReleaseRegion.worldwide:
        writer.writeByte(7);
      case ReleaseRegion.korea:
        writer.writeByte(8);
      case ReleaseRegion.brazil:
        writer.writeByte(9);
      case ReleaseRegion.unknown:
        writer.writeByte(10);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReleaseRegionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
