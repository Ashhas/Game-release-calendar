enum PlatformFilter {
  android(34, "Android", "Android"),
  ios(39, "iOS", "iOS"),
  linux(3, "Linux", "Linux"),
  mac(14, "Mac", "Mac"),
  metaQuest2(386, "Meta Quest 2", "Meta Quest 2"),
  metaQuest3(471, "Meta Quest 3", "Meta Quest 3"),
  oculusQuest(384, "Oculus Quest", "Oculus Quest"),
  oculusVR(162, "Oculus VR", "Oculus VR"),
  pc(6, "PC", "PC (Microsoft Windows)"),
  ps4(48, "PS4", "PlayStation 4"),
  ps5(167, "PS5", "PlayStation 5"),
  psvr(165, "PSVR", "PlayStation VR"),
  psvr2(390, "PSVR2", "PlayStation VR2"),
  nSwitch(130, "Switch", "Nintendo Switch"),
  steamVR(163, "Steam VR", "SteamVR"),
  vita(46, "Vita", "PlayStation Vita"),
  wiiu(41, "WiiU", "Wii U"),
  xboxOne(49, "XONE", "Xbox One"),
  xboxSeries(169, "Series X|S", "Xbox Series X|S"),
  n3ds(37, "3DS", "Nintendo 3DS"),
  windows(6, "PC", "PC (Microsoft Windows)"),
  playstation(7, "PS1", "PlayStation"),
  playstation2(8, "PS2", "PlayStation 2"),
  playstation3(9, "PS3", "PlayStation 3"),
  playstation4(48, "PS4", "PlayStation 4"),
  playstation5(167, "PS5", "PlayStation 5"),
  xbox(11, "Xbox", "Xbox"),
  xbox360(12, "Xbox 360", "Xbox 360"),
  xboxSeriesX(169, "XSX", "Xbox Series X|S"),
  nintendoSwitch(130, "Switch", "Nintendo Switch"),
  wii(5, "Wii", "Wii"),
  wiiU(41, "WiiU", "Wii U"),
  nintendoDS(20, "NDS", "Nintendo DS"),
  nintendo3DS(37, "3DS", "Nintendo 3DS"),
  segaGenesis(29, "Genesis", "Sega Mega Drive/Genesis"),
  dreamcast(23, "DC", "Dreamcast"),
  gameBoy(33, "GB", "Game Boy"),
  gameBoyAdvance(24, "GBA", "Game Boy Advance"),
  gameBoyColor(22, "GBC", "Game Boy Color"),
  stadia(84, "Stadia", "Google Stadia"),
  oculusRift(58, "Oculus", "Oculus Rift"),
  commodore64(15, "C64", "Commodore C64/128"),
  amiga(16, "Amiga", "Amiga"),
  atari2600(59, "Atari 2600", "Atari 2600"),
  atari7800(60, "Atari 7800", "Atari 7800"),
  atariLynx(61, "Atari Lynx", "Atari Lynx"),
  atariJaguar(62, "Atari Jaguar", "Atari Jaguar"),
  atariST(63, "Atari ST", "Atari ST/STE"),
  nes(18, "NES", "Nintendo Entertainment System (NES)"),
  snes(19, "SNES", "Super Nintendo Entertainment System (SNES)"),
  nintendo64(4, "N64", "Nintendo 64"),
  gameCube(21, "GC", "Nintendo GameCube"),
  segaSaturn(32, "Saturn", "Sega Saturn"),
  segaCD(78, "Sega CD", "Sega CD"),
  sega32X(30, "32X", "Sega 32X"),
  neoGeo(12, "Neo Geo", "Neo Geo"),
  pcEngine(86, "PC Engine", "TurboGrafx-16/PC Engine"),
  threeDO(50, "3DO", "3DO Interactive Multiplayer"),
  mobile(55, "Mobile", "Mobile"),
  webBrowser(82, "Web", "Web browser"),
  nintendoSwitch2(508, "Switch 2", "Nintendo Switch 2");

  final int id;
  final String abbreviation;
  final String fullName;

  const PlatformFilter(this.id, this.abbreviation, this.fullName);
}
