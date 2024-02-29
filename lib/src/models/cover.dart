class Cover {
  final int? id;
  final String? url;
  final String? imageId;

  Cover({
    required this.id,
    required this.url,
    required this.imageId,
  });

  factory Cover.fromJson(Map<String, dynamic> json) {
    return Cover(
      id: json['id'],
      url:
          json['url'].startsWith('http') ? json['url'] : 'https:${json['url']}',
      imageId: json['image_id'],
    );
  }
}
