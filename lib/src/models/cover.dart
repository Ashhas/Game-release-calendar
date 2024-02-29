class Cover {
  final int? id;
  final String? url;

  Cover({
    required this.id,
    required this.url,
  });

  factory Cover.fromJson(Map<String, dynamic> json) {
    return Cover(
      id: json['id'],
      url:
          json['url'].startsWith('http') ? json['url'] : 'https:${json['url']}',
    );
  }
}
