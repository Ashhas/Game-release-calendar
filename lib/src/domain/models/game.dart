import 'package:hive_ce/hive.dart';

import 'package:game_release_calendar/src/domain/enums/game_category.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'artwork.dart';

part 'game.g.dart';

@HiveType(typeId: 0)
class Game {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final int createdAt;

  @HiveField(2)
  final String name;

  @HiveField(3)
  final int updatedAt;

  @HiveField(4)
  final String url;

  @HiveField(5)
  final String checksum;

  @HiveField(6)
  final List<int>? ageRatings;

  @HiveField(7)
  final List<Artwork>? artworks;

  @HiveField(8)
  final GameCategory? category;

  @HiveField(9)
  final Cover? cover;

  @HiveField(10)
  final List<int>? externalGames;

  @HiveField(11)
  final int? firstReleaseDate;

  @HiveField(12)
  final List<int>? genres;

  @HiveField(13)
  final List<Platform>? platforms;

  @HiveField(14)
  final List<ReleaseDate>? releaseDates;

  @HiveField(15)
  final List<int>? screenshots;

  @HiveField(16)
  final List<int>? similarGames;

  @HiveField(17)
  final String? slug;

  @HiveField(18)
  final String? description;

  @HiveField(19)
  final List<int>? tags;

  @HiveField(20)
  final List<int>? themes;

  @HiveField(21)
  final List<int>? websites;

  @HiveField(22)
  final List<int>? languageSupports;

  @HiveField(23)
  final List<int>? gameModes;

  @HiveField(24)
  final int? status;

  @HiveField(25)
  final List<int>? multiplayerModes;

  @HiveField(26)
  final List<int>? videos;

  @HiveField(27)
  final int? versionParent;

  @HiveField(28)
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
      // ignore: avoid_dynamic
      artworks: (json['artworks'] as List<dynamic>?)
          ?.map((a) => Artwork.fromJson(a))
          .toList(),
      category: GameCategory.fromValue(json['category'] ?? 0),
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
      releaseDates: json['release_dates'] != null
          ? (json['release_dates'] as List)
              .map((e) => ReleaseDate.fromJson(e))
              .toList()
          : null,
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'name': name,
      'updated_at': updatedAt,
      'url': url,
      'checksum': checksum,
      'age_ratings': ageRatings,
      'artworks': artworks,
      'category': category?.value,
      'cover': cover?.toJson(),
      'external_games': externalGames,
      'first_release_date': firstReleaseDate,
      'genres': genres,
      'platforms': platforms?.map((e) => e.toJson()).toList(),
      'release_dates': releaseDates?.map((e) => e.toJson()).toList(),
      'screenshots': screenshots,
      'similar_games': similarGames,
      'slug': slug,
      'description': description,
      'tags': tags,
      'themes': themes,
      'websites': websites,
      'language_supports': languageSupports,
      'game_modes': gameModes,
      'status': status,
      'multiplayer_modes': multiplayerModes,
      'videos': videos,
      'version_parent': versionParent,
      'version_title': versionTitle,
    };
  }

  String _formatDate(int? epochSeconds) {
    if (epochSeconds == null) return 'null';
    return DateTime.fromMillisecondsSinceEpoch(epochSeconds * 1000)
        .toIso8601String()
        .split('T')
        .first;
  }

  @override
  String toString() {
    final platformNames = platforms?.map((p) => p.abbreviation ?? p.name).join(', ');
    final artworksList = artworks
        ?.map((a) => '    {id: ${a.id}, imageId: ${a.imageId}, gameId: ${a.game}, url: ${a.url}}')
        .join(',\n');

    return 'Game(\n'
        '  id: $id,\n'
        '  name: "$name",\n'
        '  category: ${category?.name ?? "unknown"},\n'
        '  platforms: [$platformNames],\n'
        '  firstReleaseDate: ${_formatDate(firstReleaseDate)},\n'
        '  artworks: [\n$artworksList\n  ],\n'
        '  createdAt: ${_formatDate(createdAt)},\n'
        '  updatedAt: ${_formatDate(updatedAt)},\n'
        '  url: $url\n'
        ')';
  }
}
