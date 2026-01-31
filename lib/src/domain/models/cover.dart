import 'package:hive_ce/hive.dart';

part 'cover.g.dart';

@HiveType(typeId: 2)
class Cover {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? url;

  @HiveField(2)
  final String? imageId;

  const Cover({required this.id, required this.url, required this.imageId});

  factory Cover.fromJson(Map<String, dynamic> json) {
    return Cover(
      id: json['id'],
      url: json['url'] != null && json['url'].startsWith('http')
          ? json['url']
          : 'https:${json['url']}',
      imageId: json['image_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'url': url, 'image_id': imageId};
  }

  @override
  String toString() {
    return '''Cover(
    id: $id,
    url: $url,
    imageId: $imageId
  )''';
  }

  /// Generates the full image URL with optional size (e.g., screenshot_huge, thumb, etc.)
  String imageUrl({String size = 'cover_big'}) {
    return 'https://images.igdb.com/igdb/image/upload/t_$size/$imageId.jpg';
  }
}
