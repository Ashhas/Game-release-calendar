enum PlatformFilterChoice {
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
  n3ds(37, "3DS", "Nintendo 3DS");

  final int id;
  final String abbreviation;
  final String fullName;

  const PlatformFilterChoice(this.id, this.abbreviation, this.fullName);
}
