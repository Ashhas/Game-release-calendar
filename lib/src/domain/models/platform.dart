class Platform {
  final int? id;
  final String? abbreviation;
  final String? name;
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
}
