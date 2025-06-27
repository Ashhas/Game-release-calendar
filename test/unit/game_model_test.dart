import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/enums/game_category.dart';

void main() {
  group('Game Model', () {
    test('should create game with required fields', () {
      final game = Game(
        id: 1,
        createdAt: 1640995200,
        name: 'Test Game',
        updatedAt: 1640995200,
        url: 'test-game',
        checksum: 'abc123',
        category: GameCategory.mainGame,
      );

      expect(game.id, equals(1));
      expect(game.name, equals('Test Game'));
      expect(game.category, equals(GameCategory.mainGame));
    });

    test('should handle cover imageUrl generation', () {
      final cover = Cover(
        id: 1,
        imageId: 'test123',
        url: '//images.igdb.com/igdb/image/upload/t_thumb/test123.jpg',
      );

      final imageUrl = cover.imageUrl();
      expect(
          imageUrl,
          equals(
              'https://images.igdb.com/igdb/image/upload/t_cover_big/test123.jpg'));

      final customSizeUrl = cover.imageUrl(size: 'thumb');
      expect(
          customSizeUrl,
          equals(
              'https://images.igdb.com/igdb/image/upload/t_thumb/test123.jpg'));
    });

    test('should validate basic game properties', () {
      final game = Game(
        id: 123,
        createdAt: 1640995200,
        name: 'Example Game',
        updatedAt: 1641000000,
        url: 'example-game',
        checksum: 'def456',
        category: GameCategory.dlcAddon,
      );

      expect(game.id, isA<int>());
      expect(game.name, isA<String>());
      expect(game.category, isA<GameCategory>());
      expect(game.createdAt, lessThanOrEqualTo(game.updatedAt));
    });
  });
}
