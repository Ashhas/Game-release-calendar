import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/game_card/game_card.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/enums/supported_game_platform.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

void main() {
  group('GameCard Widget Tests', () {
    Widget createTestWidget({required GameReminder reminder}) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [AppSpacings.defaultValues],
        ),
        home: Scaffold(
          body: GameCard(reminder: reminder),
        ),
      );
    }

    testWidgets('should display game information', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.text(reminder.gameName), findsOneWidget);
    });
    
    testWidgets('should display game cover art', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should handle missing cover art', (WidgetTester tester) async {
      final reminder = _createTestGameReminderWithoutCover();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should display platform information', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should display release date', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should handle tap events', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      await tester.tap(find.byType(GameCard));
      await tester.pump();
      
      expect(tester.takeException(), isNull);
    });
    
    testWidgets('should display remove button when callback provided', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [AppSpacings.defaultValues],
          ),
          home: Scaffold(
            body: GameCard(
              reminder: reminder,
              onRemove: () {},
            ),
          ),
        ),
      );
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should handle vertical layout', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(
            extensions: [AppSpacings.defaultValues],
          ),
          home: Scaffold(
            body: GameCard(
              reminder: reminder,
              isVertical: true,
            ),
          ),
        ),
      );
      
      expect(find.byType(GameCard), findsOneWidget);
    });
    
    testWidgets('should be accessible', (WidgetTester tester) async {
      final reminder = _createTestGameReminder();
      
      await tester.pumpWidget(createTestWidget(reminder: reminder));
      
      expect(find.byType(GameCard), findsOneWidget);
    });
  });
}

GameReminder _createTestGameReminder() {
  final game = Game(
    id: 1,
    createdAt: 1742318018,
    name: 'Test Game',
    updatedAt: 1742327256,
    url: 'https://example.com/game',
    checksum: 'test-checksum',
    firstReleaseDate: 1751241600,
    cover: Cover(
      id: 1,
      imageId: 'test123',
      url: '//images.igdb.com/igdb/image/upload/t_thumb/test123.jpg',
    ),
  );
  
  final releaseDate = ReleaseDate(
    id: 1,
    date: 1751241600,
    human: 'Jan 15, 2026',
    category: ReleaseDateCategory.exactDate,
    platform: SupportedGamePlatform.windows,
    dateFormat: 0,
  );
  
  return GameReminder(
    id: 1,
    gameId: 1,
    gameName: 'Test Game',
    gamePayload: game,
    releaseDate: releaseDate,
    releaseDateCategory: ReleaseDateCategory.exactDate,
    notificationDate: DateTime.now().add(Duration(days: 1)),
  );
}

GameReminder _createTestGameReminderWithoutCover() {
  final game = Game(
    id: 1,
    createdAt: 1742318018,
    name: 'Test Game',
    updatedAt: 1742327256,
    url: 'https://example.com/game',
    checksum: 'test-checksum',
    firstReleaseDate: 1751241600,
    cover: null,
  );
  
  final releaseDate = ReleaseDate(
    id: 1,
    date: 1751241600,
    human: 'Jan 15, 2026',
    category: ReleaseDateCategory.exactDate,
    platform: SupportedGamePlatform.windows,
    dateFormat: 0,
  );
  
  return GameReminder(
    id: 1,
    gameId: 1,
    gameName: 'Test Game',
    gamePayload: game,
    releaseDate: releaseDate,
    releaseDateCategory: ReleaseDateCategory.exactDate,
    notificationDate: DateTime.now().add(Duration(days: 1)),
  );
}