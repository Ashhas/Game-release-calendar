// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameAdapter extends TypeAdapter<Game> {
  @override
  final int typeId = 0;

  @override
  Game read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Game(
      id: fields[0] as int,
      createdAt: fields[1] as int,
      name: fields[2] as String,
      updatedAt: fields[3] as int,
      url: fields[4] as String,
      checksum: fields[5] as String,
      ageRatings: (fields[6] as List?)?.cast<int>(),
      artworks: (fields[7] as List?)?.cast<Artwork>(),
      category: fields[8] as GameCategory?,
      cover: fields[9] as Cover?,
      externalGames: (fields[10] as List?)?.cast<int>(),
      firstReleaseDate: fields[11] as int?,
      genres: (fields[12] as List?)?.cast<int>(),
      platforms: (fields[13] as List?)?.cast<Platform>(),
      releaseDates: (fields[14] as List?)?.cast<ReleaseDate>(),
      screenshots: (fields[15] as List?)?.cast<int>(),
      similarGames: (fields[16] as List?)?.cast<int>(),
      slug: fields[17] as String?,
      description: fields[18] as String?,
      tags: (fields[19] as List?)?.cast<int>(),
      themes: (fields[20] as List?)?.cast<int>(),
      websites: (fields[21] as List?)?.cast<int>(),
      languageSupports: (fields[22] as List?)?.cast<int>(),
      gameModes: (fields[23] as List?)?.cast<int>(),
      status: fields[24] as int?,
      multiplayerModes: (fields[25] as List?)?.cast<int>(),
      videos: (fields[26] as List?)?.cast<int>(),
      versionParent: fields[27] as int?,
      versionTitle: fields[28] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Game obj) {
    writer
      ..writeByte(29)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.createdAt)
      ..writeByte(2)
      ..write(obj.name)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.url)
      ..writeByte(5)
      ..write(obj.checksum)
      ..writeByte(6)
      ..write(obj.ageRatings)
      ..writeByte(7)
      ..write(obj.artworks)
      ..writeByte(8)
      ..write(obj.category)
      ..writeByte(9)
      ..write(obj.cover)
      ..writeByte(10)
      ..write(obj.externalGames)
      ..writeByte(11)
      ..write(obj.firstReleaseDate)
      ..writeByte(12)
      ..write(obj.genres)
      ..writeByte(13)
      ..write(obj.platforms)
      ..writeByte(14)
      ..write(obj.releaseDates)
      ..writeByte(15)
      ..write(obj.screenshots)
      ..writeByte(16)
      ..write(obj.similarGames)
      ..writeByte(17)
      ..write(obj.slug)
      ..writeByte(18)
      ..write(obj.description)
      ..writeByte(19)
      ..write(obj.tags)
      ..writeByte(20)
      ..write(obj.themes)
      ..writeByte(21)
      ..write(obj.websites)
      ..writeByte(22)
      ..write(obj.languageSupports)
      ..writeByte(23)
      ..write(obj.gameModes)
      ..writeByte(24)
      ..write(obj.status)
      ..writeByte(25)
      ..write(obj.multiplayerModes)
      ..writeByte(26)
      ..write(obj.videos)
      ..writeByte(27)
      ..write(obj.versionParent)
      ..writeByte(28)
      ..write(obj.versionTitle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
