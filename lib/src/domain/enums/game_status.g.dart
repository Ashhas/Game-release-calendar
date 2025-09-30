// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameStatusAdapter extends TypeAdapter<GameStatus> {
  @override
  final int typeId = 14;

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
        break;
      case GameStatus.alpha:
        writer.writeByte(1);
        break;
      case GameStatus.beta:
        writer.writeByte(2);
        break;
      case GameStatus.earlyAccess:
        writer.writeByte(3);
        break;
      case GameStatus.offline:
        writer.writeByte(4);
        break;
      case GameStatus.cancelled:
        writer.writeByte(5);
        break;
      case GameStatus.rumored:
        writer.writeByte(6);
        break;
      case GameStatus.delisted:
        writer.writeByte(7);
        break;
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
