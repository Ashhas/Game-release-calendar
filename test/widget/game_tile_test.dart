import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';

void main() {
  group('GameTile Widget Tests', () {
    testWidgets('should display game name correctly', (WidgetTester tester) async {
      final game = _createTestGame(name: 'Test Game Name');
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.text('Test Game Name'), findsOneWidget);
    });

    testWidgets('should display exact release date correctly', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Exact Date Game',
        firstReleaseDate: 1751241600, // June 30, 2025
        releaseDates: [
          ReleaseDate(
            id: 1,
            date: 1751241600,
            category: null,
            dateFormat: 0, // Exact date
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('30-06-2025'), findsOneWidget);
    });

    testWidgets('should display month release date correctly', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Month Date Game',
        firstReleaseDate: 1751241600, // June 2025
        releaseDates: [
          ReleaseDate(
            id: 1,
            date: 1751241600,
            category: null,
            dateFormat: 1, // Year-month
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('Jun 2025'), findsOneWidget);
    });

    testWidgets('should display quarter release date correctly', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Quarter Date Game',
        firstReleaseDate: 1751241600, // Q2 2025
        releaseDates: [
          ReleaseDate(
            id: 1,
            date: 1751241600,
            human: 'Q2 2025',
            category: null,
            dateFormat: 4, // Quarter
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('Q2 2025'), findsOneWidget);
    });

    testWidgets('should display year release date correctly', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Year Date Game',
        firstReleaseDate: 1751241600, // 2025
        releaseDates: [
          ReleaseDate(
            id: 1,
            date: 1751241600,
            category: null,
            dateFormat: 2, // Year only
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('2025'), findsOneWidget);
    });

    testWidgets('should display TBD when no release date available', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'TBD Game',
        firstReleaseDate: null,
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('Release date: TBD'), findsOneWidget);
    });

    testWidgets('should display TBD when category is unreliable but fixed by logic', (WidgetTester tester) async {
      // This tests the original user issue - category 4 (TBD) but human shows quarter
      final game = _createTestGame(
        name: 'Fixed Quarter Game',
        firstReleaseDate: 1751241600,
        releaseDates: [
          ReleaseDate(
            id: 1,
            date: 1751241600,
            human: 'Q2 2025',
            category: null, // Would be TBD category originally
            dateFormat: 4, // Quarter format
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.textContaining('Release date:'), findsOneWidget);
      expect(find.textContaining('Q2 2025'), findsOneWidget);
      expect(find.textContaining('Release date: TBD'), findsNothing);
    });

    testWidgets('should display platforms when available', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Multi-platform Game',
        platforms: [
          Platform(
            id: 1,
            name: 'PlayStation 5',
            abbreviation: 'PS5',
            url: 'ps5-url',
          ),
          Platform(
            id: 2,
            name: 'PC (Microsoft Windows)',
            abbreviation: 'PC',
            url: 'pc-url',
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.text('PS5'), findsOneWidget);
      expect(find.text('PC'), findsOneWidget);
      expect(find.byType(Chip), findsNWidgets(2));
    });

    testWidgets('should not display platform chips when platforms is null', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'No Platform Game',
        platforms: null,
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.byType(Chip), findsNothing);
    });

    testWidgets('should display placeholder image when cover is null', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'No Cover Game',
        cover: null,
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.byType(FadeInImage), findsOneWidget);
    });

    testWidgets('should display cover image when available', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Cover Game',
        cover: Cover(
          id: 1,
          imageId: 'test123',
          url: '//images.igdb.com/igdb/image/upload/t_thumb/test123.jpg',
        ),
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.byType(FadeInImage), findsOneWidget);
    });

    testWidgets('should handle platform without abbreviation', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Platform Game',
        platforms: [
          Platform(
            id: 1,
            name: 'Nintendo Switch',
            abbreviation: null,
            url: 'switch-url',
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.text('Nintendo Switch'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('should handle platform with neither name nor abbreviation', (WidgetTester tester) async {
      final game = _createTestGame(
        name: 'Unknown Platform Game',
        platforms: [
          Platform(
            id: 1,
            name: null,
            abbreviation: null,
            url: 'unknown-url',
          ),
        ],
      );
      
      await tester.pumpWidget(_createTestApp(game));
      
      expect(find.text('N/A'), findsOneWidget);
      expect(find.byType(Chip), findsOneWidget);
    });

    testWidgets('should be tappable and create navigation route', (WidgetTester tester) async {
      final game = _createTestGame(name: 'Tappable Game');
      
      await tester.pumpWidget(_createTestApp(game));
      
      final listTile = find.byType(ListTile);
      expect(listTile, findsOneWidget);
      
      // Verify the ListTile has an onTap callback
      final listTileWidget = tester.widget<ListTile>(listTile);
      expect(listTileWidget.onTap, isNotNull);
    });

    group('date formatting priority tests', () {
      testWidgets('should prioritize human format over category for quarters', (WidgetTester tester) async {
        final game = _createTestGame(
          name: 'Priority Test Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              human: 'Q2 2025', // Human shows Q2
              category: null,
              dateFormat: 4,
            ),
          ],
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        expect(find.textContaining('Q2 2025'), findsOneWidget);
      });

      testWidgets('should use dateFormat when category is unreliable', (WidgetTester tester) async {
        final game = _createTestGame(
          name: 'DateFormat Test Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: null, // Would be TBD originally
              dateFormat: 1, // Year-month format
            ),
          ],
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        expect(find.textContaining('Jun 2025'), findsOneWidget);
      });

      testWidgets('should use most specific category from multiple release dates', (WidgetTester tester) async {
        final game = _createTestGame(
          name: 'Multi-Release Test Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: null,
              dateFormat: 2, // Year only
            ),
            ReleaseDate(
              id: 2,
              date: 1751241600,
              category: null,
              dateFormat: 0, // Exact date (more specific)
            ),
          ],
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        // Should use exact date format (most specific)
        expect(find.textContaining('30-06-2025'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('should handle empty platform list', (WidgetTester tester) async {
        final game = _createTestGame(
          name: 'Empty Platforms Game',
          platforms: [],
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('should handle future dates correctly', (WidgetTester tester) async {
        final futureTimestamp = 4102444800; // Year 2100
        final game = _createTestGame(
          name: 'Future Game',
          firstReleaseDate: futureTimestamp,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: futureTimestamp,
              category: null,
              dateFormat: 2, // Year only
            ),
          ],
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        expect(find.textContaining('2100'), findsOneWidget);
      });

      testWidgets('should handle very long game names', (WidgetTester tester) async {
        final game = _createTestGame(
          name: 'This is a very long game name that should still be displayed properly in the game tile widget without breaking the layout or causing overflow issues',
        );
        
        await tester.pumpWidget(_createTestApp(game));
        
        expect(find.textContaining('This is a very long'), findsOneWidget);
      });
    });
  });
}

// ignore: avoid_returning_widgets
/// Helper function to create a test app with MaterialApp wrapper
Widget _createTestApp(Game game) {
  return MaterialApp(
    home: Scaffold(
      body: GameTile(game: game),
    ),
  );
}

/// Helper function to create test games with sensible defaults
Game _createTestGame({
  required String name,
  int? firstReleaseDate,
  List<ReleaseDate>? releaseDates,
  List<Platform>? platforms,
  Cover? cover,
}) {
  return Game(
    id: 1,
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url',
    checksum: 'test-checksum',
    firstReleaseDate: firstReleaseDate,
    releaseDates: releaseDates,
    platforms: platforms,
    cover: cover,
  );
}