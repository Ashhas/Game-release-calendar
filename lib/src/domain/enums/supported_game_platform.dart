import 'package:hive/hive.dart';

part 'supported_game_platform.g.dart';

@HiveType(typeId: 5)
enum SupportedGamePlatform {
  @HiveField(0)
  android(34, "Android", "Android"),
  @HiveField(1)
  ios(39, "iOS", "iOS"),
  @HiveField(2)
  linux(3, "Linux", "Linux"),
  @HiveField(3)
  mac(14, "Mac", "Mac"),
  @HiveField(4)
  metaQuest2(386, "Meta Quest 2", "Meta Quest 2"),
  @HiveField(5)
  metaQuest3(471, "Meta Quest 3", "Meta Quest 3"),
  @HiveField(6)
  windows(6, "PC", "PC (Microsoft Windows)"),
  @HiveField(7)
  playstation(7, "PS1", "PlayStation"),
  @HiveField(8)
  playstation2(8, "PS2", "PlayStation 2"),
  @HiveField(9)
  playstation3(9, "PS3", "PlayStation 3"),
  @HiveField(10)
  playstation4(48, "PS4", "PlayStation 4"),
  @HiveField(11)
  playstation5(167, "PS5", "PlayStation 5"),
  @HiveField(12)
  xbox(11, "Xbox", "Xbox"),
  @HiveField(13)
  xbox360(12, "Xbox 360", "Xbox 360"),
  @HiveField(14)
  xboxOne(49, "XONE", "Xbox One"),
  @HiveField(15)
  xboxSeriesX(169, "XSX", "Xbox Series X|S"),
  @HiveField(16)
  nintendoSwitch(130, "Switch", "Nintendo Switch"),
  @HiveField(17)
  wii(5, "Wii", "Wii"),
  @HiveField(18)
  wiiU(41, "WiiU", "Wii U"),
  @HiveField(19)
  nintendoDS(20, "NDS", "Nintendo DS"),
  @HiveField(20)
  nintendo3DS(37, "3DS", "Nintendo 3DS"),
  @HiveField(21)
  segaGenesis(29, "Genesis", "Sega Mega Drive/Genesis"),
  @HiveField(22)
  dreamcast(23, "DC", "Dreamcast"),
  @HiveField(23)
  gameBoy(33, "GB", "Game Boy"),
  @HiveField(24)
  gameBoyAdvance(24, "GBA", "Game Boy Advance"),
  @HiveField(25)
  gameBoyColor(22, "GBC", "Game Boy Color"),
  @HiveField(26)
  stadia(84, "Stadia", "Google Stadia"),
  @HiveField(27)
  oculusRift(58, "Oculus", "Oculus Rift"),
  @HiveField(28)
  commodore64(15, "C64", "Commodore C64/128"),
  @HiveField(29)
  amiga(16, "Amiga", "Amiga"),
  @HiveField(30)
  atari2600(59, "Atari 2600", "Atari 2600"),
  @HiveField(31)
  atari7800(60, "Atari 7800", "Atari 7800"),
  @HiveField(32)
  atariLynx(61, "Atari Lynx", "Atari Lynx"),
  @HiveField(33)
  atariJaguar(62, "Atari Jaguar", "Atari Jaguar"),
  @HiveField(34)
  atariST(63, "Atari ST", "Atari ST/STE"),
  @HiveField(35)
  nes(18, "NES", "Nintendo Entertainment System (NES)"),
  @HiveField(36)
  snes(19, "SNES", "Super Nintendo Entertainment System (SNES)"),
  @HiveField(37)
  nintendo64(4, "N64", "Nintendo 64"),
  @HiveField(38)
  gameCube(21, "GC", "Nintendo GameCube"),
  @HiveField(39)
  segaSaturn(32, "Saturn", "Sega Saturn"),
  @HiveField(40)
  segaCD(78, "Sega CD", "Sega CD"),
  @HiveField(41)
  sega32X(30, "32X", "Sega 32X"),
  @HiveField(42)
  neoGeo(12, "Neo Geo", "Neo Geo"),
  @HiveField(43)
  pcEngine(86, "PC Engine", "TurboGrafx-16/PC Engine"),
  @HiveField(44)
  threeDO(50, "3DO", "3DO Interactive Multiplayer"),
  @HiveField(45)
  mobile(55, "Mobile", "Mobile"),
  @HiveField(46)
  webBrowser(82, "Web", "Web browser"),
  @HiveField(47)
  nintendoSwitch2(508, "Switch 2", "Nintendo Switch 2"),
  @HiveField(48)
  oculusQuest(384, "Oculus Quest", "Oculus Quest"),
  @HiveField(49)
  oculusVR(162, "Oculus VR", "Oculus VR"),
  @HiveField(50)
  steamVR(163, "Steam VR", "Steam VR"),
  @HiveField(51)
  psvr(165, "PSVR", "PlayStation VR"),
  @HiveField(52)
  psvr2(390, "PSVR2", "PlayStation VR2"),
  @HiveField(53)
  vita(46, "Vita", "PlayStation Vita"),
  @HiveField(100)
  noSuchPlatform(0, "Unknown", "Unknown");

  final int id;
  final String abbreviation;
  final String fullName;

  const SupportedGamePlatform(this.id, this.abbreviation, this.fullName);

  int toValue() => id;

  static SupportedGamePlatform fromValue(int value) {
    return SupportedGamePlatform.values.firstWhere(
      (platform) => platform.id == value,
      orElse: () => noSuchPlatform,
    );
  }

  @override
  String toString() {
    return '''SupportedGamePlatform(
    id: $id,
    abbreviation: $abbreviation,
    name: $name,
    fullName: $fullName
  )''';
  }
}
