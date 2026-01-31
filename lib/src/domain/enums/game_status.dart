import 'package:hive_ce/hive.dart';

part 'game_status.g.dart';

@HiveType(typeId: 14)
enum GameStatus {
  @HiveField(0)
  released(0, 'Released'),

  @HiveField(1)
  alpha(2, 'Alpha'),

  @HiveField(2)
  beta(3, 'Beta'),

  @HiveField(3)
  earlyAccess(4, 'Early Access'),

  @HiveField(4)
  offline(5, 'Offline'),

  @HiveField(5)
  cancelled(6, 'Cancelled'),

  @HiveField(6)
  rumored(7, 'Rumored'),

  @HiveField(7)
  delisted(8, 'Delisted');

  final int value;
  final String displayText;

  const GameStatus(this.value, this.displayText);

  static GameStatus? fromValue(int? value) {
    if (value == null) return null;

    try {
      return GameStatus.values.firstWhere((status) => status.value == value);
    } catch (_) {
      return null;
    }
  }

  static String getStatusText(int? status) {
    final gameStatus = fromValue(status);
    return gameStatus?.displayText ??
        (status != null ? 'Status $status' : 'Unknown');
  }

  @override
  String toString() {
    return '''GameStatus(
      value: $value,
      displayText: $displayText
    )''';
  }
}
