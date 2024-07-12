import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';

class Game {
  final int id;
  final int createdAt;
  final String name;
  final int updatedAt;
  final String url;
  final String checksum;

  // Nullable fields
  final List<int>? ageRatings;
  final List<int>? artworks;
  final int? category;
  final Cover? cover;
  final List<int>? externalGames;
  final int? firstReleaseDate;
  final List<int>? genres;
  final List<Platform>? platforms;
  final List<int>? releaseDates;
  final List<int>? screenshots;
  final List<int>? similarGames;
  final String? slug;
  final String? description;
  final List<int>? tags;
  final List<int>? themes;
  final List<int>? websites;
  final List<int>? languageSupports;
  final List<int>? gameModes;
  final int? status;
  final List<int>? multiplayerModes;
  final List<int>? videos;
  final int? versionParent;
  final String? versionTitle;

  const Game({
    required this.id,
    required this.createdAt,
    required this.name,
    required this.updatedAt,
    required this.url,
    required this.checksum,
    this.ageRatings,
    this.artworks,
    this.category,
    this.cover,
    this.externalGames,
    this.firstReleaseDate,
    this.genres,
    this.platforms,
    this.releaseDates,
    this.screenshots,
    this.similarGames,
    this.slug,
    this.description,
    this.tags,
    this.themes,
    this.websites,
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
      cover: json['cover'] != null ? Cover.fromJson(json['cover']) : null,
      createdAt: json['created_at'],
      externalGames: json['external_games']?.cast<int>(),
      firstReleaseDate: json['first_release_date'],
      genres: json['genres']?.cast<int>(),
      name: json['name'],
      platforms: json['platforms'] != null
          ? (json['platforms'] as List)
              .map((e) => Platform.fromJson(e))
              .toList()
          : null,
      releaseDates: json['release_dates']?.cast<int>(),
      screenshots: json['screenshots']?.cast<int>(),
      similarGames: json['similar_games']?.cast<int>(),
      slug: json['slug'],
      description: json['description'],
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
