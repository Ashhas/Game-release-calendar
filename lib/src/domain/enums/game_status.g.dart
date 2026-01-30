// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStatusAdapter extends TypeAdapter<GameStatus> {
  @override
  final typeId = 14;

  @override
  GameStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return GameStatus.released;
      case 1:
        return GameStatus.alpha;
      case 2:
        return GameStatus.beta;
      case 3:
        return GameStatus.earlyAccess;
      case 4:
        return GameStatus.offline;
      case 5:
        return GameStatus.cancelled;
      case 6:
        return GameStatus.rumored;
      case 7:
        return GameStatus.delisted;
      default:
        return GameStatus.released;
    }
  }

  @override
  void write(BinaryWriter writer, GameStatus obj) {
    switch (obj) {
      case GameStatus.released:
        writer.writeByte(0);
      case GameStatus.alpha:
        writer.writeByte(1);
      case GameStatus.beta:
        writer.writeByte(2);
      case GameStatus.earlyAccess:
        writer.writeByte(3);
      case GameStatus.offline:
        writer.writeByte(4);
      case GameStatus.cancelled:
        writer.writeByte(5);
      case GameStatus.rumored:
        writer.writeByte(6);
      case GameStatus.delisted:
        writer.writeByte(7);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
