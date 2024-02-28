class Game {
  final int id;
  final List<int>? ageRatings;
  final List<int>? artworks;
  final int? category;
  final int? cover;
  final int createdAt;
  final List<int>? externalGames;
  final int? firstReleaseDate;
  final List<int>? genres;
  final String name;
  final List<int>? platforms;
  final List<int>? releaseDates;
  final List<int>? screenshots;
  final List<int>? similarGames;
  final String? slug;
  final String? description;
  final List<int>? tags;
  final List<int>? themes;
  final int updatedAt;
  final String url;
  final List<int>? websites;
  final String checksum;
  final List<int>? languageSupports;
  final List<int>? gameModes;
  final int? status;
  final List<int>? multiplayerModes;
  final List<int>? videos;
  final int? versionParent;
  final String? versionTitle;

  Game({
    required this.id,
    this.ageRatings,
    this.artworks,
    this.category,
    this.cover,
    required this.createdAt,
    this.externalGames,
    this.firstReleaseDate,
    this.genres,
    required this.name,
    this.platforms,
    this.releaseDates,
    this.screenshots,
    this.similarGames,
    this.slug,
    this.description,
    this.tags,
    this.themes,
    required this.updatedAt,
    required this.url,
    this.websites,
    required this.checksum,
    this.languageSupports,
    this.gameModes,
    this.status,
    this.multiplayerModes,
    this.videos,
    this.versionParent,
    this.versionTitle,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'],
      ageRatings: json['age_ratings']?.cast<int>(),
      artworks: json['artworks']?.cast<int>(),
      category: json['category'],
      cover: json['cover'],
      createdAt: json['created_at'],
      externalGames: json['external_games']?.cast<int>(),
      firstReleaseDate: json['first_release_date'],
      genres: json['genres']?.cast<int>(),
      name: json['name'],
      platforms: json['platforms']?.cast<int>(),
      releaseDates: json['release_dates']?.cast<int>(),
      screenshots: json['screenshots']?.cast<int>(),
      similarGames: json['similar_games']?.cast<int>(),
      slug: json['slug'],
      description: json['description'],
      // Adjust based on actual key for the description
      tags: json['tags']?.cast<int>(),
      themes: json['themes']?.cast<int>(),
      updatedAt: json['updated_at'],
      url: json['url'],
      websites: json['websites']?.cast<int>(),
      checksum: json['checksum'],
      languageSupports: json['language_supports']?.cast<int>(),
      gameModes: json['game_modes']?.cast<int>(),
      status: json['status'],
      multiplayerModes: json['multiplayer_modes']?.cast<int>(),
      videos: json['videos']?.cast<int>(),
      versionParent: json['version_parent'],
      versionTitle: json['version_title'],
    );
  }
}
