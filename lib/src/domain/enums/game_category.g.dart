// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameCategoryAdapter extends TypeAdapter<GameCategory> {
  @override
  final typeId = 8;

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
      case GameCategory.dlcAddon:
        writer.writeByte(1);
      case GameCategory.expansion:
        writer.writeByte(2);
      case GameCategory.bundle:
        writer.writeByte(3);
      case GameCategory.standaloneExpansion:
        writer.writeByte(4);
      case GameCategory.mod:
        writer.writeByte(5);
      case GameCategory.episode:
        writer.writeByte(6);
      case GameCategory.season:
        writer.writeByte(7);
      case GameCategory.remake:
        writer.writeByte(8);
      case GameCategory.remaster:
        writer.writeByte(9);
      case GameCategory.expandedGame:
        writer.writeByte(10);
      case GameCategory.port:
        writer.writeByte(11);
      case GameCategory.fork:
        writer.writeByte(12);
      case GameCategory.pack:
        writer.writeByte(13);
      case GameCategory.update:
        writer.writeByte(14);
      case GameCategory.fangame:
        writer.writeByte(15);
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
