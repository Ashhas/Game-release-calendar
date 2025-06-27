import 'package:hive/hive.dart';

part 'game_category.g.dart';

@HiveType(typeId: 8)
enum GameCategory {
  @HiveField(0)
  mainGame(0, 'Main Game'),

  @HiveField(1)
  dlcAddon(1, 'DLC / Addon'),

  @HiveField(2)
  expansion(2, 'Expansion'),

  @HiveField(3)
  bundle(3, 'Bundle'),

  @HiveField(4)
  standaloneExpansion(4, 'Standalone Expansion'),

  @HiveField(5)
  mod(5, 'Mod'),

  @HiveField(6)
  episode(6, 'Episode'),

  @HiveField(7)
  season(7, 'Season'),

  @HiveField(8)
  remake(8, 'Remake'),

  @HiveField(9)
  remaster(9, 'Remaster'),

  @HiveField(10)
  expandedGame(10, 'Expanded Game'),

  @HiveField(11)
  port(11, 'Port'),

  @HiveField(12)
  fork(12, 'Fork'),

  @HiveField(13)
  pack(13, 'Pack'),

  @HiveField(14)
  update(14, 'Update'),

  @HiveField(15)
  fangame(15, 'Fangame');

  final int value;
  final String description;

  const GameCategory(this.value, this.description);

  static GameCategory fromValue(int value) {
    return GameCategory.values.firstWhere(
      (e) => e.value == value,
      orElse: () => GameCategory.mainGame,
    );
  }

  int toValue() => value;

  @override
  String toString() {
    return '''GameCategory(
      id: $value,
      enum: $name,
      description: $description
    )''';
  }
}
