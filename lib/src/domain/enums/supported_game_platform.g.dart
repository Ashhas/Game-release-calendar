// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_game_platform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupportedGamePlatformAdapter extends TypeAdapter<SupportedGamePlatform> {
  @override
  final int typeId = 5;

  @override
  SupportedGamePlatform read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return SupportedGamePlatform.android;
      case 1:
        return SupportedGamePlatform.ios;
      case 2:
        return SupportedGamePlatform.linux;
      case 3:
        return SupportedGamePlatform.mac;
      case 4:
        return SupportedGamePlatform.metaQuest2;
      case 5:
        return SupportedGamePlatform.metaQuest3;
      case 100:
        return SupportedGamePlatform.noSuchPlatform;
      default:
        return SupportedGamePlatform.android;
    }
  }

  @override
  void write(BinaryWriter writer, SupportedGamePlatform obj) {
    switch (obj) {
      case SupportedGamePlatform.android:
        writer.writeByte(0);
        break;
      case SupportedGamePlatform.ios:
        writer.writeByte(1);
        break;
      case SupportedGamePlatform.linux:
        writer.writeByte(2);
        break;
      case SupportedGamePlatform.mac:
        writer.writeByte(3);
        break;
      case SupportedGamePlatform.metaQuest2:
        writer.writeByte(4);
        break;
      case SupportedGamePlatform.metaQuest3:
        writer.writeByte(5);
        break;
      case SupportedGamePlatform.noSuchPlatform:
        writer.writeByte(100);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupportedGamePlatformAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
