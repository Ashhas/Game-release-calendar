enum SupportedGamePlatform {
  android(34, "Android", "Android"),
  ios(39, "iOS", "iOS"),
  linux(3, "Linux", "Linux"),
  mac(14, "Mac", "Mac"),
  metaQuest2(386, "Meta Quest 2", "Meta Quest 2"),
  metaQuest3(471, "Meta Quest 3", "Meta Quest 3"),
  oculusQuest(384, "Oculus Quest", "Oculus Quest"),
  oculusVR(162, "Oculus VR", "Oculus VR"),
  pc(6, "PC", "PC (Microsoft Windows)"),
  ps1(7, "PS1", "PlayStation"),
  ps2(8, "PS2", "PlayStation 2"),
  ps3(9, "PS3", "PlayStation 3"),
  ps4(48, "PS4", "PlayStation 4"),
  ps5(167, "PS5", "PlayStation 5"),
  psvr(165, "PSVR", "PlayStation VR"),
  psvr2(390, "PSVR2", "PlayStation VR2"),
  vita(46, "Vita", "PlayStation Vita"),
  n64(4, "N64", "Nintendo 64"),
  nSwitch(130, "Switch", "Nintendo Switch"),
  wii(5, "Wii", "Nintendo Wii"),
  wiiu(41, "WiiU", "Nintendo Wii U"),
  n3ds(37, "3DS", "Nintendo 3DS"),
  nds(20, "NDS", "Nintendo DS"),
  nGage(42, "N-Gage", "N-Gage"),
  dreamcast(23, "DC", "Dreamcast"),
  xbox(11, "XBOX", "Xbox"),
  xbox360(12, "X360", "Xbox 360"),
  xboxOne(49, "XONE", "Xbox One"),
  xboxSeries(169, "Series X|S", "Xbox Series X|S"),
  steamVR(163, "Steam VR", "SteamVR"),
  stadia(170, "Stadia", "Google Stadia"),
  segaGenesis(29, "Genesis/MegaDrive", "Sega Mega Drive/Genesis"),
  segaCD(78, "Sega CD", "Sega CD"),
  segaSaturn(32, "Saturn", "Sega Saturn"),
  segaGameGear(35, "Game Gear", "Sega Game Gear"),
  atari2600(59, "Atari2600", "Atari 2600"),
  atari7800(60, "Atari7800", "Atari 7800"),
  atariLynx(61, "Lynx", "Atari Lynx"),
  atariJaguar(62, "Jaguar", "Atari Jaguar"),
  commodore64(15, "C64", "Commodore C64/128/MAX"),
  amiga(16, "Amiga", "Amiga"),
  appleII(75, "Apple][", "Apple II"),
  ouya(72, "Ouya", "Ouya"),
  blackberry(73, "BlackBerry", "BlackBerry OS"),
  windowsPhone(74, "Win Phone", "Windows Phone"),
  webBrowser(82, "Browser", "Web Browser"),
  metaQuest(384, "Meta Quest", "Meta Quest"),
  onlive(113, "OnLive", "OnLive Game System"),
  neoGeoPocket(119, "NGPC", "Neo Geo Pocket"),
  neoGeoPocketColor(120, "NGPC Color", "Neo Geo Pocket Color"),
  sharpX68000(121, "X68000", "Sharp X68000"),
  pc8800(125, "PC-8800", "PC-8800 Series"),
  trs80(126, "TRS-80", "TRS-80"),
  fairchild(127, "Channel F", "Fairchild Channel F"),
  pcSuperGrafx(128, "SuperGrafx", "PC Engine SuperGrafx"),
  ti99(129, "TI-99", "Texas Instruments TI-99"),
  amazonFireTV(132, "Fire TV", "Amazon Fire TV"),
  arcade(52, "Arcade", "Arcade"),
  oculusRift(385, "Oculus Rift", "Oculus Rift"),
  oculusGo(387, "Oculus Go", "Oculus Go"),
  gearVR(388, "Gear VR", "Gear VR"),
  airConsole(389, "AirConsole", "AirConsole"),
  visionOS(472, "visionOS", "visionOS"),
  applePippin(476, "Pippin", "Apple Pippin"),
  panasonicJungle(477, "Jungle", "Panasonic Jungle"),
  superAcan(480, "Super A'Can", "Super A'Can"),
  segaCD32X(482, "Sega CD 32X", "Sega CD 32X"),
  digiblast(486, "DigiBlast", "DigiBlast"),
  laserActive(487, "LaserActive", "LaserActive"),
  segaPico(339, "Pico", "Sega Pico"),
  epochVision(375, "Epoch CV", "Epoch Cassette Vision"),
  wonderswan(57, "WonderSwan", "WonderSwan"),
  wonderswanColor(123, "WonderSwan Color", "WonderSwan Color"),
  colecoVision(68, "ColecoVision", "ColecoVision"),
  vic20(71, "VIC-20", "Commodore VIC-20"),
  vectrex(70, "Vectrex", "Vectrex"),
  gameWatch(307, "G&W", "Game & Watch"),
  leapster(412, "Leapster", "Leapster"),
  palmOS(417, "Palm OS", "Palm OS"),
  noSuchPlatform(000, "Unknown", "Unknown");

  final int id;
  final String abbreviation;
  final String fullName;

  const SupportedGamePlatform(this.id, this.abbreviation, this.fullName);

  int toValue() => id;

  static SupportedGamePlatform? fromValue(int value) {
    return SupportedGamePlatform.values.firstWhere(
      (platform) => platform.id == value,
      orElse: () => noSuchPlatform,
    );
  }
}