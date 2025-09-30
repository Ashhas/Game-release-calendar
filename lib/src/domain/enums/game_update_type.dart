import 'package:hive/hive.dart';

part 'game_update_type.g.dart';

@HiveType(typeId: 12)
enum GameUpdateType {
  @HiveField(0)
  releaseDate(0, 'Release Date Updated'),

  @HiveField(1)
  coverImage(1, 'Cover Image Updated'),

  @HiveField(2)
  gameInfo(2, 'Game Info Updated'),

  @HiveField(3)
  platforms(3, 'Platform Added'),

  @HiveField(4)
  descriptionUpdate(4, 'Description Updated'),

  @HiveField(5)
  status(5, 'Status Updated'),

  @HiveField(6)
  artwork(6, 'Artwork Updated'),

  @HiveField(7)
  checksum(7, 'Data Checksum Updated');

  final int value;
  final String displayText;

  const GameUpdateType(this.value, this.displayText);

  static GameUpdateType fromValue(int value) {
    return GameUpdateType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GameUpdateType.gameInfo,
    );
  }

  int toValue() => value;

  @override
  String toString() {
    return '''GameUpdateType(
      id: $value,
      enum: $name,
      displayText: $displayText
    )''';
  }
}