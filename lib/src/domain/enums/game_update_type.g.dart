// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_update_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameUpdateTypeAdapter extends TypeAdapter<GameUpdateType> {
  @override
  final int typeId = 12;

  @override
  GameUpdateType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameUpdateType.releaseDate;
      case 1:
        return GameUpdateType.coverImage;
      case 2:
        return GameUpdateType.gameInfo;
      case 3:
        return GameUpdateType.platforms;
      case 4:
        return GameUpdateType.descriptionUpdate;
      case 5:
        return GameUpdateType.status;
      case 6:
        return GameUpdateType.artwork;
      case 7:
        return GameUpdateType.checksum;
      default:
        return GameUpdateType.releaseDate;
    }
  }

  @override
  void write(BinaryWriter writer, GameUpdateType obj) {
    switch (obj) {
      case GameUpdateType.releaseDate:
        writer.writeByte(0);
        break;
      case GameUpdateType.coverImage:
        writer.writeByte(1);
        break;
      case GameUpdateType.gameInfo:
        writer.writeByte(2);
        break;
      case GameUpdateType.platforms:
        writer.writeByte(3);
        break;
      case GameUpdateType.descriptionUpdate:
        writer.writeByte(4);
        break;
      case GameUpdateType.status:
        writer.writeByte(5);
        break;
      case GameUpdateType.artwork:
        writer.writeByte(6);
        break;
      case GameUpdateType.checksum:
        writer.writeByte(7);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameUpdateTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
