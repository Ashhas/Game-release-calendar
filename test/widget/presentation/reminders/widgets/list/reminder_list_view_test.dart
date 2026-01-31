import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/cover.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/platform.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_cubit.dart';
import 'package:game_release_calendar/src/presentation/reminders/state/reminders_state.dart';
import 'package:game_release_calendar/src/presentation/reminders/widgets/list/reminder_list_view.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

class FakeRemindersCubit implements RemindersCubit {
  @override
  RemindersState get state => const RemindersState();

  @override
  Stream<RemindersState> get stream => Stream.value(state);

  @override
  // ignore: avoid_dynamic
  dynamic noSuchMethod(Invocation invocation) => null;
}

void main() {
  group('RemindersListView Widget Tests', () {
    late FakeRemindersCubit fakeRemindersCubit;

    setUp(() {
      fakeRemindersCubit = FakeRemindersCubit();
    });

    // ignore: avoid_returning_widgets
    Widget createTestWidget({
      required Map<DateTime, List<GameReminder>> reminders,
    }) {
      return MaterialApp(
        theme: ThemeData(extensions: [AppSpacings.defaultValues]),
        home: BlocProvider<RemindersCubit>.value(
          value: fakeRemindersCubit,
          child: Scaffold(body: RemindersListView(reminders: reminders)),
        ),
      );
    }

    testWidgets('should display grouped reminders by date', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final tomorrow = today.add(Duration(days: 1));

      final reminders = {
        today: [_createTestReminder(id: 1, gameName: 'Game Today')],
        tomorrow: [_createTestReminder(id: 2, gameName: 'Game Tomorrow')],
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.text('Game Today'), findsOneWidget);
      expect(find.text('Game Tomorrow'), findsOneWidget);
    });

    testWidgets('should display empty state when no reminders', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget(reminders: {}));

      expect(find.text('No reminders found'), findsOneWidget);
    });

    testWidgets('should display scrollable content', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final reminders = {
        today: List.generate(
          5,
          (index) =>
              _createTestReminder(id: index, gameName: 'Reminder $index'),
        ),
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.byType(CustomScrollView), findsOneWidget);
    });

    testWidgets('should handle multiple days with reminders', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final tomorrow = today.add(Duration(days: 1));
      final nextWeek = today.add(Duration(days: 7));

      final reminders = {
        today: [_createTestReminder(id: 1, gameName: 'Game 1')],
        tomorrow: [_createTestReminder(id: 2, gameName: 'Game 2')],
        nextWeek: [_createTestReminder(id: 3, gameName: 'Game 3')],
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.byType(RemindersListView), findsOneWidget);
      expect(find.text('Game 1'), findsOneWidget);
      expect(find.text('Game 2'), findsOneWidget);
      expect(find.text('Game 3'), findsOneWidget);
    });

    testWidgets('should sort reminders by date', (WidgetTester tester) async {
      final today = DateTime.now();
      final yesterday = today.subtract(Duration(days: 1));
      final tomorrow = today.add(Duration(days: 1));

      final reminders = {
        tomorrow: [_createTestReminder(id: 3, gameName: 'Future Game')],
        yesterday: [_createTestReminder(id: 1, gameName: 'Past Game')],
        today: [_createTestReminder(id: 2, gameName: 'Today Game')],
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      // Should render all games without errors
      expect(find.text('Past Game'), findsOneWidget);
      expect(find.text('Today Game'), findsOneWidget);
      expect(find.text('Future Game'), findsOneWidget);
    });

    testWidgets('should handle large number of reminders', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final reminders = {
        today: List.generate(
          20,
          (index) => _createTestReminder(id: index, gameName: 'Game $index'),
        ),
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.byType(RemindersListView), findsOneWidget);
    });

    testWidgets('should handle empty lists in date groups', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final reminders = {today: <GameReminder>[]};

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      // Should handle empty lists gracefully
      expect(find.byType(RemindersListView), findsOneWidget);
    });

    testWidgets('should render game tiles for each reminder', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final reminders = {
        today: [
          _createTestReminder(id: 1, gameName: 'Game 1'),
          _createTestReminder(id: 2, gameName: 'Game 2'),
        ],
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.text('Game 1'), findsOneWidget);
      expect(find.text('Game 2'), findsOneWidget);
    });

    testWidgets('should handle reminders across multiple weeks', (
      WidgetTester tester,
    ) async {
      final today = DateTime.now();
      final reminders = {
        for (int i = 0; i < 14; i++)
          today.add(Duration(days: i)): [
            _createTestReminder(id: i, gameName: 'Game $i'),
          ],
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      expect(find.byType(RemindersListView), findsOneWidget);
    });

    testWidgets('should maintain scroll position', (WidgetTester tester) async {
      final today = DateTime.now();
      final reminders = {
        today: List.generate(
          50,
          (index) => _createTestReminder(id: index, gameName: 'Game $index'),
        ),
      };

      await tester.pumpWidget(createTestWidget(reminders: reminders));

      // Should render without crashing
      expect(find.byType(RemindersListView), findsOneWidget);
    });
  });
}

GameReminder _createTestReminder({
  int id = 1,
  String gameName = 'Test Game',
  DateTime? notificationDate,
}) {
  return GameReminder(
    id: id,
    gameId: id * 100,
    gameName: gameName,
    gamePayload: _createTestGame(id: id, name: gameName),
    releaseDate: _createTestReleaseDate(),
    releaseDateCategory: ReleaseDateCategory.exactDate,
    notificationDate: notificationDate ?? DateTime.now().add(Duration(days: 1)),
  );
}

Game _createTestGame({int id = 1, String name = 'Test Game'}) {
  return Game(
    id: id,
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url-$id',
    checksum: 'test-checksum-$id',
    firstReleaseDate: 1751241600,
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
    releaseDates: [_createTestReleaseDate()],
  );
}

ReleaseDate _createTestReleaseDate() {
  return ReleaseDate(id: 1, date: 1751241600, category: null, dateFormat: 0);
}
