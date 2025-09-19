import 'package:hive/hive.dart';

part 'artwork.g.dart';

@HiveType(typeId: 7)
class Artwork {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String imageId;

  @HiveField(2)
  final String url;

  @HiveField(3)
  final bool? alphaChannel;

  @HiveField(4)
  final bool? animated;

  @HiveField(5)
  final int? width;

  @HiveField(6)
  final int? height;

  @HiveField(7)
  final int game;

  @HiveField(8)
  final String? checksum;

  const Artwork({
    required this.id,
    required this.imageId,
    required this.url,
    required this.game,
    this.alphaChannel,
    this.animated,
    this.checksum,
    this.width,
    this.height,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'],
      url: json['url'],
      width: json['width'],
      height: json['height'],
      alphaChannel: json['alpha_channel'] ?? false,
      animated: json['animated'] ?? false,
      game: json['game'],
      imageId: json['image_id'],
      checksum: json['checksum'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'url': url,
      'game': game,
      'alpha_channel': alphaChannel,
      'animated': animated,
      'image_id': imageId,
      'width': width,
      'height': height,
      'checksum': checksum,
    };
  }

  @override
  String toString() {
    return 'Artwork(id: $id, imageId: $imageId, gameId: $game, imageUrl: $url, size: ${width}x$height, animated: $animated, alphaChannel: $alphaChannel)';
  }

  /// Generates the full image URL with optional size (e.g., screenshot_huge, thumb, etc.)
  String imageUrl({String size = 'screenshot_huge'}) {
    return 'https://images.igdb.com/igdb/image/upload/t_$size/$imageId.jpg';
  }
}
