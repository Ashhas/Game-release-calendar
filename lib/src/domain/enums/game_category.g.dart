// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameCategoryAdapter extends TypeAdapter<GameCategory> {
  @override
  final int typeId = 8;

  @override
  GameCategory read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameCategory.mainGame;
      case 1:
        return GameCategory.dlcAddon;
      case 2:
        return GameCategory.expansion;
      case 3:
        return GameCategory.bundle;
      case 4:
        return GameCategory.standaloneExpansion;
      case 5:
        return GameCategory.mod;
      case 6:
        return GameCategory.episode;
      case 7:
        return GameCategory.season;
      case 8:
        return GameCategory.remake;
      case 9:
        return GameCategory.remaster;
      case 10:
        return GameCategory.expandedGame;
      case 11:
        return GameCategory.port;
      case 12:
        return GameCategory.fork;
      case 13:
        return GameCategory.pack;
      case 14:
        return GameCategory.update;
      case 15:
        return GameCategory.fangame;
      default:
        return GameCategory.mainGame;
    }
  }

  @override
  void write(BinaryWriter writer, GameCategory obj) {
    switch (obj) {
      case GameCategory.mainGame:
        writer.writeByte(0);
        break;
      case GameCategory.dlcAddon:
        writer.writeByte(1);
        break;
      case GameCategory.expansion:
        writer.writeByte(2);
        break;
      case GameCategory.bundle:
        writer.writeByte(3);
        break;
      case GameCategory.standaloneExpansion:
        writer.writeByte(4);
        break;
      case GameCategory.mod:
        writer.writeByte(5);
        break;
      case GameCategory.episode:
        writer.writeByte(6);
        break;
      case GameCategory.season:
        writer.writeByte(7);
        break;
      case GameCategory.remake:
        writer.writeByte(8);
        break;
      case GameCategory.remaster:
        writer.writeByte(9);
        break;
      case GameCategory.expandedGame:
        writer.writeByte(10);
        break;
      case GameCategory.port:
        writer.writeByte(11);
        break;
      case GameCategory.fork:
        writer.writeByte(12);
        break;
      case GameCategory.pack:
        writer.writeByte(13);
        break;
      case GameCategory.update:
        writer.writeByte(14);
        break;
      case GameCategory.fangame:
        writer.writeByte(15);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
