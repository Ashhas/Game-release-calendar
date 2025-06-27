// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'release_region.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReleaseRegionAdapter extends TypeAdapter<ReleaseRegion> {
  @override
  final int typeId = 9;

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
        break;
      case ReleaseRegion.northAmerica:
        writer.writeByte(1);
        break;
      case ReleaseRegion.australia:
        writer.writeByte(2);
        break;
      case ReleaseRegion.newZealand:
        writer.writeByte(3);
        break;
      case ReleaseRegion.japan:
        writer.writeByte(4);
        break;
      case ReleaseRegion.china:
        writer.writeByte(5);
        break;
      case ReleaseRegion.asia:
        writer.writeByte(6);
        break;
      case ReleaseRegion.worldwide:
        writer.writeByte(7);
        break;
      case ReleaseRegion.korea:
        writer.writeByte(8);
        break;
      case ReleaseRegion.brazil:
        writer.writeByte(9);
        break;
      case ReleaseRegion.unknown:
        writer.writeByte(10);
        break;
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
