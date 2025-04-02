import 'package:hive/hive.dart';

part 'artwork.g.dart';

@HiveType(typeId: 7)
class Artwork {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final int? width;

  @HiveField(3)
  final int? height;

  Artwork({
    required this.id,
    required this.url,
    this.width,
    this.height,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'width': width,
      'height': height,
    };
  }

  @override
  String toString() {
    return 'Artwork(id: $id, url: $url, width: $width, height: $height)';
  }
}
