// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supported_game_platform.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SupportedGamePlatformAdapter extends TypeAdapter<SupportedGamePlatform> {
  @override
  final typeId = 5;

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
      case 48:
        return SupportedGamePlatform.oculusQuest;
      case 49:
        return SupportedGamePlatform.oculusVR;
      case 50:
        return SupportedGamePlatform.steamVR;
      case 51:
        return SupportedGamePlatform.psvr;
      case 52:
        return SupportedGamePlatform.psvr2;
      case 53:
        return SupportedGamePlatform.vita;
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
      case SupportedGamePlatform.ios:
        writer.writeByte(1);
      case SupportedGamePlatform.linux:
        writer.writeByte(2);
      case SupportedGamePlatform.mac:
        writer.writeByte(3);
      case SupportedGamePlatform.metaQuest2:
        writer.writeByte(4);
      case SupportedGamePlatform.metaQuest3:
        writer.writeByte(5);
      case SupportedGamePlatform.windows:
        writer.writeByte(6);
      case SupportedGamePlatform.playstation:
        writer.writeByte(7);
      case SupportedGamePlatform.playstation2:
        writer.writeByte(8);
      case SupportedGamePlatform.playstation3:
        writer.writeByte(9);
      case SupportedGamePlatform.playstation4:
        writer.writeByte(10);
      case SupportedGamePlatform.playstation5:
        writer.writeByte(11);
      case SupportedGamePlatform.xbox:
        writer.writeByte(12);
      case SupportedGamePlatform.xbox360:
        writer.writeByte(13);
      case SupportedGamePlatform.xboxOne:
        writer.writeByte(14);
      case SupportedGamePlatform.xboxSeriesX:
        writer.writeByte(15);
      case SupportedGamePlatform.nintendoSwitch:
        writer.writeByte(16);
      case SupportedGamePlatform.wii:
        writer.writeByte(17);
      case SupportedGamePlatform.wiiU:
        writer.writeByte(18);
      case SupportedGamePlatform.nintendoDS:
        writer.writeByte(19);
      case SupportedGamePlatform.nintendo3DS:
        writer.writeByte(20);
      case SupportedGamePlatform.segaGenesis:
        writer.writeByte(21);
      case SupportedGamePlatform.dreamcast:
        writer.writeByte(22);
      case SupportedGamePlatform.gameBoy:
        writer.writeByte(23);
      case SupportedGamePlatform.gameBoyAdvance:
        writer.writeByte(24);
      case SupportedGamePlatform.gameBoyColor:
        writer.writeByte(25);
      case SupportedGamePlatform.stadia:
        writer.writeByte(26);
      case SupportedGamePlatform.oculusRift:
        writer.writeByte(27);
      case SupportedGamePlatform.commodore64:
        writer.writeByte(28);
      case SupportedGamePlatform.amiga:
        writer.writeByte(29);
      case SupportedGamePlatform.atari2600:
        writer.writeByte(30);
      case SupportedGamePlatform.atari7800:
        writer.writeByte(31);
      case SupportedGamePlatform.atariLynx:
        writer.writeByte(32);
      case SupportedGamePlatform.atariJaguar:
        writer.writeByte(33);
      case SupportedGamePlatform.atariST:
        writer.writeByte(34);
      case SupportedGamePlatform.nes:
        writer.writeByte(35);
      case SupportedGamePlatform.snes:
        writer.writeByte(36);
      case SupportedGamePlatform.nintendo64:
        writer.writeByte(37);
      case SupportedGamePlatform.gameCube:
        writer.writeByte(38);
      case SupportedGamePlatform.segaSaturn:
        writer.writeByte(39);
      case SupportedGamePlatform.segaCD:
        writer.writeByte(40);
      case SupportedGamePlatform.sega32X:
        writer.writeByte(41);
      case SupportedGamePlatform.neoGeo:
        writer.writeByte(42);
      case SupportedGamePlatform.pcEngine:
        writer.writeByte(43);
      case SupportedGamePlatform.threeDO:
        writer.writeByte(44);
      case SupportedGamePlatform.mobile:
        writer.writeByte(45);
      case SupportedGamePlatform.webBrowser:
        writer.writeByte(46);
      case SupportedGamePlatform.nintendoSwitch2:
        writer.writeByte(47);
      case SupportedGamePlatform.oculusQuest:
        writer.writeByte(48);
      case SupportedGamePlatform.oculusVR:
        writer.writeByte(49);
      case SupportedGamePlatform.steamVR:
        writer.writeByte(50);
      case SupportedGamePlatform.psvr:
        writer.writeByte(51);
      case SupportedGamePlatform.psvr2:
        writer.writeByte(52);
      case SupportedGamePlatform.vita:
        writer.writeByte(53);
      case SupportedGamePlatform.noSuchPlatform:
        writer.writeByte(100);
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
