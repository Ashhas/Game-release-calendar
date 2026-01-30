import 'package:hive_ce/hive.dart';

part 'platform.g.dart';

@HiveType(typeId: 1)
class Platform {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? abbreviation;

  @HiveField(2)
  final String? name;

  @HiveField(3)
  final String? url;

  const Platform({
    required this.id,
    required this.abbreviation,
    required this.name,
    required this.url,
  });

  factory Platform.fromJson(Map<String, dynamic> json) {
    return Platform(
      id: json['id'],
      abbreviation: json['abbreviation'],
      name: json['name'],
      url: json['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'abbreviation': abbreviation,
      'name': name,
      'url': url,
    };
  }

  @override
  String toString() {
    return '''Platform(
    id: $id,
    abbreviation: $abbreviation,
    name: $name,
    url: $url
  )''';
  }
}
