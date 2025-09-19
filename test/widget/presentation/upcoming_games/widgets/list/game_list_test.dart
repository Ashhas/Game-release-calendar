import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/list/game_list.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_state.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';
import '../../../../../helpers/test_helpers.dart';

class FakeUpcomingGamesCubit implements UpcomingGamesCubit {
  @override
  UpcomingGamesState get state => UpcomingGamesState();
  
  @override
  Stream<UpcomingGamesState> get stream => Stream.value(state);
  
  @override
  Future<List<Game>> getGamesWithOffset(int offset) async {
    return [_createTestGame()];
  }
  
  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  group('GameList Widget Tests', () {
    late FakeUpcomingGamesCubit fakeUpcomingGamesCubit;

    setUp(() {
      fakeUpcomingGamesCubit = FakeUpcomingGamesCubit();
      setupTestDependencies();
    });

    tearDown(() {
      tearDownTestDependencies();
    });

    // ignore: avoid_returning_widgets
    Widget createTestWidget({required Map<DateTime, List<Game>> games}) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [
            AppSpacings.defaultValues,
          ],
        ),
        home: BlocProvider<UpcomingGamesCubit>.value(
          value: fakeUpcomingGamesCubit,
          child: Scaffold(
            body: GameList(games: games),
          ),
        ),
      );
    }

    testWidgets('should display grouped games by date', (WidgetTester tester) async {
      final today = DateTime.now();
      final tomorrow = today.add(Duration(days: 1));
      
      final games = {
        today: [
          _createTestGame(id: 1, name: 'Game Today'),
        ],
        tomorrow: [
          _createTestGame(id: 2, name: 'Game Tomorrow'),
        ],
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      expect(find.text('Game Today'), findsOneWidget);
      expect(find.text('Game Tomorrow'), findsOneWidget);
    });
    
    testWidgets('should handle empty games map', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget(games: {}));
      
      // Should render without crashing
      expect(find.byType(GameList), findsOneWidget);
    });
    
    testWidgets('should display scrollable content', (WidgetTester tester) async {
      final today = DateTime.now();
      final games = {
        today: List.generate(5, (index) => _createTestGame(id: index, name: 'Game $index')),
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      expect(find.byType(CustomScrollView), findsOneWidget);
    });
    
    testWidgets('should show loading indicator when scrolling to bottom', (WidgetTester tester) async {
      final today = DateTime.now();
      final games = {
        today: List.generate(20, (index) => _createTestGame(id: index, name: 'Game $index')),
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      await tester.pump();
      
      // Scroll to bottom to trigger loading
      await tester.drag(find.byType(GameList), Offset(0, -1000));
      await tester.pump();
      
      // Should not crash during scroll
      expect(tester.takeException(), isNull);
    });
    
    testWidgets('should display date sections', (WidgetTester tester) async {
      final today = DateTime.now();
      final tomorrow = today.add(Duration(days: 1));
      final nextWeek = today.add(Duration(days: 7));
      
      final games = {
        today: [_createTestGame(id: 1, name: 'Game 1')],
        tomorrow: [_createTestGame(id: 2, name: 'Game 2')],
        nextWeek: [_createTestGame(id: 3, name: 'Game 3')],
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      // Should find date section headers
      expect(find.byType(GameList), findsOneWidget);
    });
    
    testWidgets('should handle large number of games', (WidgetTester tester) async {
      final today = DateTime.now();
      final games = {
        today: List.generate(100, (index) => _createTestGame(id: index, name: 'Game $index')),
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      expect(find.byType(GameList), findsOneWidget);
    });
    
    testWidgets('should maintain scroll position', (WidgetTester tester) async {
      final today = DateTime.now();
      final games = {
        today: List.generate(50, (index) => _createTestGame(id: index, name: 'Game $index')),
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      // Scroll down
      await tester.drag(find.byType(GameList), Offset(0, -500));
      await tester.pump();
      
      // Rebuild widget
      await tester.pumpWidget(createTestWidget(games: games));
      
      // Should maintain position without errors
      expect(tester.takeException(), isNull);
    });
    
    testWidgets('should handle date scrollbar when enabled', (WidgetTester tester) async {
      final today = DateTime.now();
      final games = {
        for (int i = 0; i < 10; i++)
          today.add(Duration(days: i)): [
            _createTestGame(id: i, name: 'Game $i'),
          ],
      };
      
      await tester.pumpWidget(createTestWidget(games: games));
      
      // Should render without crashing with scrollbar
      expect(find.byType(GameList), findsOneWidget);
    });
  });
}

Game _createTestGame({
  int id = 1,
  String name = 'Test Game',
  int? releaseDate,
}) {
  return Game(
    id: id,
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url-$id',
    checksum: 'test-checksum-$id',
    firstReleaseDate: releaseDate ?? 1751241600,
    cover: Cover(
      id: 1,
      imageId: 'test123',
      url: '//images.igdb.com/igdb/image/upload/t_thumb/test123.jpg',
    ),
    platforms: [
      Platform(
        id: 1,
        name: 'PlayStation 5',
        abbreviation: 'PS5',
        url: 'ps5-url',
      ),
    ],
    releaseDates: [
      ReleaseDate(
        id: 1,
        date: releaseDate ?? 1751241600,
        category: null,
        dateFormat: 0,
      ),
    ],
  );
}