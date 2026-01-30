import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/game.dart';
import 'package:game_release_calendar/src/domain/models/notifications/game_reminder.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';
import 'package:game_release_calendar/src/utils/constants.dart';
import 'package:game_release_calendar/src/utils/game_date_grouper.dart';

void main() {
  group('GameDateGrouper', () {
    group('tbdDate', () {
      test('should return maxDateLimit constant', () {
        expect(GameDateGrouper.tbdDate, equals(Constants.maxDateLimit));
        expect(GameDateGrouper.tbdDate, equals(DateTime(9999, 1, 1)));
      });
    });

    group('groupGamesByReleaseDate', () {
      test('should group games by release date correctly', () {
        final games = [
          _createGame(id: 1, name: 'Game A', firstReleaseDate: 1751241600), // June 27, 2025
          _createGame(id: 2, name: 'Game B', firstReleaseDate: 1751241600), // June 27, 2025
          _createGame(id: 3, name: 'Game C', firstReleaseDate: 1753833600), // July 15, 2025
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);

        expect(result.keys.length, equals(2));
        expect(result[DateTime(2025, 6, 30)]?.length, equals(2));
        expect(result[DateTime(2025, 7, 30)]?.length, equals(1));
      });

      test('should group games with null release dates under tbdDate', () {
        final games = [
          _createGame(id: 1, name: 'Game A', firstReleaseDate: 1751241600),
          _createGame(id: 2, name: 'Game B', firstReleaseDate: null),
          _createGame(id: 3, name: 'Game C', firstReleaseDate: null),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);

        expect(result.keys.length, equals(2));
        expect(result[GameDateGrouper.tbdDate]?.length, equals(2));
        expect(result[DateTime(2025, 6, 30)]?.length, equals(1));
      });

      test('should sort games within same day by category specificity', () {
        final sameTimestamp = 1751241600; // June 27, 2025
        final games = [
          _createGame(
            id: 1,
            name: 'TBD Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: sameTimestamp,
                category: null,
                dateFormat: null,
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Exact Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: sameTimestamp,
                category: null,
                dateFormat: 0, // Exact date
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'Quarter Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4, // Quarter
              ),
            ],
          ),
          _createGame(
            id: 4,
            name: 'Year Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 4,
                date: sameTimestamp,
                category: null,
                dateFormat: 2, // Year only
              ),
            ],
          ),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedGames = result[DateTime(2025, 6, 30)]!;

        // Should be sorted by category specificity: exact -> quarter -> year -> tbd
        expect(sortedGames.first.name, equals('Exact Game'));
        expect(sortedGames[1].name, equals('Quarter Game'));
        expect(sortedGames[2].name, equals('Year Game'));
        expect(sortedGames[3].name, equals('TBD Game'));
      });

      test('should sort alphabetically within same category', () {
        final sameTimestamp = 1751241600;
        final games = [
          _createGame(
            id: 1,
            name: 'Zebra Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: sameTimestamp,
                category: null,
                dateFormat: 0, // Exact date
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Alpha Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: sameTimestamp,
                category: null,
                dateFormat: 0, // Exact date
              ),
            ],
          ),
          _createGame(
            id: 3,
            name: 'Beta Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: sameTimestamp,
                category: null,
                dateFormat: 0, // Exact date
              ),
            ],
          ),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedGames = result[DateTime(2025, 6, 30)]!;

        expect(sortedGames.first.name, equals('Alpha Game'));
        expect(sortedGames[1].name, equals('Beta Game'));
        expect(sortedGames[2].name, equals('Zebra Game'));
      });

      test('should handle complex multi-level sorting correctly', () {
        final sameTimestamp = 1751241600;
        final games = [
          // Two games with same quarter format
          _createGame(
            id: 1,
            name: 'Zelda Quarter',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 1,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          _createGame(
            id: 2,
            name: 'Alpha Quarter',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 2,
                date: sameTimestamp,
                human: 'Q2 2025',
                category: null,
                dateFormat: 4,
              ),
            ],
          ),
          // One exact date game
          _createGame(
            id: 3,
            name: 'Exact Game',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 3,
                date: sameTimestamp,
                category: null,
                dateFormat: 0,
              ),
            ],
          ),
          // Two games with same month format
          _createGame(
            id: 4,
            name: 'Zulu Month',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 4,
                date: sameTimestamp,
                category: null,
                dateFormat: 1,
              ),
            ],
          ),
          _createGame(
            id: 5,
            name: 'Alpha Month',
            firstReleaseDate: sameTimestamp,
            releaseDates: [
              ReleaseDate(
                id: 5,
                date: sameTimestamp,
                category: null,
                dateFormat: 1,
              ),
            ],
          ),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);
        final sortedGames = result[DateTime(2025, 6, 30)]!;

        // Expected order:
        // 1. Exact Game (most specific category)
        // 2. Alpha Month (month category, alphabetically first)
        // 3. Zulu Month (month category, alphabetically second)
        // 4. Alpha Quarter (quarter category, alphabetically first)
        // 5. Zelda Quarter (quarter category, alphabetically second)
        expect(sortedGames.first.name, equals('Exact Game'));
        expect(sortedGames[1].name, equals('Alpha Month'));
        expect(sortedGames[2].name, equals('Zulu Month'));
        expect(sortedGames[3].name, equals('Alpha Quarter'));
        expect(sortedGames[4].name, equals('Zelda Quarter'));
      });

      test('should handle empty games list', () {
        final result = GameDateGrouper.groupGamesByReleaseDate([]);
        expect(result, isEmpty);
      });

      test('should preserve exact timestamps when grouping by date only', () {
        final timestamp1 = 1751241600; // June 30, 2025 00:00:00 UTC
        final timestamp2 = 1751061600; // June 28, 2025 00:00:00 UTC
        final games = [
          _createGame(id: 1, name: 'Game A', firstReleaseDate: timestamp1),
          _createGame(id: 2, name: 'Game B', firstReleaseDate: timestamp2),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);

        // Convert timestamps to actual dates to compare
        final date1 = DateTime.fromMillisecondsSinceEpoch(timestamp1 * 1000);
        final date2 = DateTime.fromMillisecondsSinceEpoch(timestamp2 * 1000);
        final expectedDate1 = DateTime(date1.year, date1.month, date1.day);
        final expectedDate2 = DateTime(date2.year, date2.month, date2.day);

        expect(result.keys.length, equals(2));
        expect(result.containsKey(expectedDate1), isTrue);
        expect(result.containsKey(expectedDate2), isTrue);
      });

      test('should handle games with multiple release dates', () {
        final game = _createGame(
          id: 1,
          name: 'Multi-Platform Game',
          firstReleaseDate: 1751241600,
          releaseDates: [
            ReleaseDate(
              id: 1,
              date: 1751241600,
              category: null,
              dateFormat: 3, // Quarter
            ),
            ReleaseDate(
              id: 2,
              date: 1751241600,
              category: null,
              dateFormat: 0, // Exact date (more specific)
            ),
          ],
        );

        final result = GameDateGrouper.groupGamesByReleaseDate([game]);
        final groupedGame = result[DateTime(2025, 6, 30)]!.first;

        // Should use the most specific category for sorting
        expect(groupedGame.name, equals('Multi-Platform Game'));
      });
    });

    group('groupRemindersByReleaseDate', () {
      test('should group reminders by release date correctly', () {
        final reminders = [
          _createReminder(id: 1, releaseTimestamp: 1751241600), // June 27, 2025
          _createReminder(id: 2, releaseTimestamp: 1751241600), // June 27, 2025
          _createReminder(id: 3, releaseTimestamp: 1753833600), // July 15, 2025
        ];

        final result = GameDateGrouper.groupRemindersByReleaseDate(reminders);

        expect(result.keys.length, equals(2));
        expect(result[DateTime(2025, 6, 30)]?.length, equals(2));
        expect(result[DateTime(2025, 7, 30)]?.length, equals(1));
      });

      test('should group reminders with null timestamps under tbdDate', () {
        final reminders = [
          _createReminder(id: 1, releaseTimestamp: 1751241600),
          _createReminder(id: 2, releaseTimestamp: null),
          _createReminder(id: 3, releaseTimestamp: null),
        ];

        final result = GameDateGrouper.groupRemindersByReleaseDate(reminders);

        expect(result.keys.length, equals(2));
        expect(result[GameDateGrouper.tbdDate]?.length, equals(2));
        expect(result[DateTime(2025, 6, 30)]?.length, equals(1));
      });

      test('should handle empty reminders list', () {
        final result = GameDateGrouper.groupRemindersByReleaseDate([]);
        expect(result, isEmpty);
      });

      test('should sort reminders by game name within same date', () {
        final reminders = [
          _createReminder(id: 3, releaseTimestamp: 1751241600),
          _createReminder(id: 1, releaseTimestamp: 1751241600),
          _createReminder(id: 2, releaseTimestamp: 1751241600),
        ];

        final result = GameDateGrouper.groupRemindersByReleaseDate(reminders);
        final groupedReminders = result[DateTime(2025, 6, 30)]!;

        // Should be sorted by game name: 'Test Game 1', 'Test Game 2', 'Test Game 3'
        expect(groupedReminders.first.id, equals(1));
        expect(groupedReminders[1].id, equals(2));
        expect(groupedReminders[2].id, equals(3));
      });
    });

    group('edge cases', () {
      test('should handle games with identical data correctly', () {
        final timestamp = 1751241600;
        final games = List.generate(3, (index) => 
          _createGame(
            id: index,
            name: 'Identical Game', // Same name
            firstReleaseDate: timestamp, // Same timestamp
            releaseDates: [
              ReleaseDate(
                id: index,
                date: timestamp,
                category: null,
                dateFormat: 0, // Same category
              ),
            ],
          ),
        );

        final result = GameDateGrouper.groupGamesByReleaseDate(games);
        final groupedGames = result[DateTime(2025, 6, 30)]!;

        expect(groupedGames.length, equals(3));
        // All games should be sorted consistently (maintaining some order)
        for (final game in groupedGames) {
          expect(game.name, equals('Identical Game'));
        }
      });

      test('should handle very large timestamps', () {
        final farFutureTimestamp = 4102444800; // Year 2100
        final game = _createGame(
          id: 1,
          name: 'Future Game',
          firstReleaseDate: farFutureTimestamp,
        );

        final result = GameDateGrouper.groupGamesByReleaseDate([game]);
        
        expect(result.keys.length, equals(1));
        expect(result.keys.first.year, equals(2100));
      });

      test('should handle mixed null and valid timestamps', () {
        final games = [
          _createGame(id: 1, name: 'Valid Game', firstReleaseDate: 1751241600),
          _createGame(id: 2, name: 'Null Game 1', firstReleaseDate: null),
          _createGame(id: 3, name: 'Another Valid', firstReleaseDate: 1753833600),
          _createGame(id: 4, name: 'Null Game 2', firstReleaseDate: null),
        ];

        final result = GameDateGrouper.groupGamesByReleaseDate(games);

        expect(result.keys.length, equals(3)); // Two valid dates + tbdDate
        expect(result[GameDateGrouper.tbdDate]?.length, equals(2));
        expect(result[DateTime(2025, 6, 30)]?.length, equals(1));
        expect(result[DateTime(2025, 7, 30)]?.length, equals(1));
      });
    });
  });
}

/// Helper function to create test games
Game _createGame({
  required int id,
  required String name,
  int? firstReleaseDate,
  List<ReleaseDate>? releaseDates,
}) {
  return Game(
    id: id,
    createdAt: 1742318018,
    name: name,
    updatedAt: 1742327256,
    url: 'test-url-$id',
    checksum: 'test-checksum-$id',
    firstReleaseDate: firstReleaseDate,
    releaseDates: releaseDates,
  );
}

/// Helper function to create test reminders
GameReminder _createReminder({
  required int id,
  int? releaseTimestamp,
}) {
  final testGame = _createGame(id: id, name: 'Test Game $id');
  final testReleaseDate = ReleaseDate(
    id: id,
    date: releaseTimestamp,
  );
  
  return GameReminder(
    id: id,
    gameId: id,
    gameName: 'Test Game $id',
    gamePayload: testGame,
    releaseDate: testReleaseDate,
    releaseDateCategory: releaseTimestamp != null 
        ? ReleaseDateCategory.exactDate 
        : ReleaseDateCategory.tbd,
    notificationDate: DateTime.now().add(Duration(days: 1)),
  );
}
