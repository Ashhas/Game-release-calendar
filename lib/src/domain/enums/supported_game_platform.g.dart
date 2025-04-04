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
      case 6:
        return SupportedGamePlatform.windows;
      case 7:
        return SupportedGamePlatform.playstation;
      case 8:
        return SupportedGamePlatform.playstation2;
      case 9:
        return SupportedGamePlatform.playstation3;
      case 10:
        return SupportedGamePlatform.playstation4;
      case 11:
        return SupportedGamePlatform.playstation5;
      case 12:
        return SupportedGamePlatform.xbox;
      case 13:
        return SupportedGamePlatform.xbox360;
      case 14:
        return SupportedGamePlatform.xboxOne;
      case 15:
        return SupportedGamePlatform.xboxSeriesX;
      case 16:
        return SupportedGamePlatform.nintendoSwitch;
      case 17:
        return SupportedGamePlatform.wii;
      case 18:
        return SupportedGamePlatform.wiiU;
      case 19:
        return SupportedGamePlatform.nintendoDS;
      case 20:
        return SupportedGamePlatform.nintendo3DS;
      case 21:
        return SupportedGamePlatform.segaGenesis;
      case 22:
        return SupportedGamePlatform.dreamcast;
      case 23:
        return SupportedGamePlatform.gameBoy;
      case 24:
        return SupportedGamePlatform.gameBoyAdvance;
      case 25:
        return SupportedGamePlatform.gameBoyColor;
      case 26:
        return SupportedGamePlatform.stadia;
      case 27:
        return SupportedGamePlatform.oculusRift;
      case 28:
        return SupportedGamePlatform.commodore64;
      case 29:
        return SupportedGamePlatform.amiga;
      case 30:
        return SupportedGamePlatform.atari2600;
      case 31:
        return SupportedGamePlatform.atari7800;
      case 32:
        return SupportedGamePlatform.atariLynx;
      case 33:
        return SupportedGamePlatform.atariJaguar;
      case 34:
        return SupportedGamePlatform.atariST;
      case 35:
        return SupportedGamePlatform.nes;
      case 36:
        return SupportedGamePlatform.snes;
      case 37:
        return SupportedGamePlatform.nintendo64;
      case 38:
        return SupportedGamePlatform.gameCube;
      case 39:
        return SupportedGamePlatform.segaSaturn;
      case 40:
        return SupportedGamePlatform.segaCD;
      case 41:
        return SupportedGamePlatform.sega32X;
      case 42:
        return SupportedGamePlatform.neoGeo;
      case 43:
        return SupportedGamePlatform.pcEngine;
      case 44:
        return SupportedGamePlatform.threeDO;
      case 45:
        return SupportedGamePlatform.mobile;
      case 46:
        return SupportedGamePlatform.webBrowser;
      case 47:
        return SupportedGamePlatform.nintendoSwitch2;
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
      case SupportedGamePlatform.windows:
        writer.writeByte(6);
        break;
      case SupportedGamePlatform.playstation:
        writer.writeByte(7);
        break;
      case SupportedGamePlatform.playstation2:
        writer.writeByte(8);
        break;
      case SupportedGamePlatform.playstation3:
        writer.writeByte(9);
        break;
      case SupportedGamePlatform.playstation4:
        writer.writeByte(10);
        break;
      case SupportedGamePlatform.playstation5:
        writer.writeByte(11);
        break;
      case SupportedGamePlatform.xbox:
        writer.writeByte(12);
        break;
      case SupportedGamePlatform.xbox360:
        writer.writeByte(13);
        break;
      case SupportedGamePlatform.xboxOne:
        writer.writeByte(14);
        break;
      case SupportedGamePlatform.xboxSeriesX:
        writer.writeByte(15);
        break;
      case SupportedGamePlatform.nintendoSwitch:
        writer.writeByte(16);
        break;
      case SupportedGamePlatform.wii:
        writer.writeByte(17);
        break;
      case SupportedGamePlatform.wiiU:
        writer.writeByte(18);
        break;
      case SupportedGamePlatform.nintendoDS:
        writer.writeByte(19);
        break;
      case SupportedGamePlatform.nintendo3DS:
        writer.writeByte(20);
        break;
      case SupportedGamePlatform.segaGenesis:
        writer.writeByte(21);
        break;
      case SupportedGamePlatform.dreamcast:
        writer.writeByte(22);
        break;
      case SupportedGamePlatform.gameBoy:
        writer.writeByte(23);
        break;
      case SupportedGamePlatform.gameBoyAdvance:
        writer.writeByte(24);
        break;
      case SupportedGamePlatform.gameBoyColor:
        writer.writeByte(25);
        break;
      case SupportedGamePlatform.stadia:
        writer.writeByte(26);
        break;
      case SupportedGamePlatform.oculusRift:
        writer.writeByte(27);
        break;
      case SupportedGamePlatform.commodore64:
        writer.writeByte(28);
        break;
      case SupportedGamePlatform.amiga:
        writer.writeByte(29);
        break;
      case SupportedGamePlatform.atari2600:
        writer.writeByte(30);
        break;
      case SupportedGamePlatform.atari7800:
        writer.writeByte(31);
        break;
      case SupportedGamePlatform.atariLynx:
        writer.writeByte(32);
        break;
      case SupportedGamePlatform.atariJaguar:
        writer.writeByte(33);
        break;
      case SupportedGamePlatform.atariST:
        writer.writeByte(34);
        break;
      case SupportedGamePlatform.nes:
        writer.writeByte(35);
        break;
      case SupportedGamePlatform.snes:
        writer.writeByte(36);
        break;
      case SupportedGamePlatform.nintendo64:
        writer.writeByte(37);
        break;
      case SupportedGamePlatform.gameCube:
        writer.writeByte(38);
        break;
      case SupportedGamePlatform.segaSaturn:
        writer.writeByte(39);
        break;
      case SupportedGamePlatform.segaCD:
        writer.writeByte(40);
        break;
      case SupportedGamePlatform.sega32X:
        writer.writeByte(41);
        break;
      case SupportedGamePlatform.neoGeo:
        writer.writeByte(42);
        break;
      case SupportedGamePlatform.pcEngine:
        writer.writeByte(43);
        break;
      case SupportedGamePlatform.threeDO:
        writer.writeByte(44);
        break;
      case SupportedGamePlatform.mobile:
        writer.writeByte(45);
        break;
      case SupportedGamePlatform.webBrowser:
        writer.writeByte(46);
        break;
      case SupportedGamePlatform.nintendoSwitch2:
        writer.writeByte(47);
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
