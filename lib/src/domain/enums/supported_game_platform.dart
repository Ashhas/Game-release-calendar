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
  // Add the remaining platforms here with unique @HiveField numbers...
  @HiveField(100)
  noSuchPlatform(000, "Unknown", "Unknown");

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
}
