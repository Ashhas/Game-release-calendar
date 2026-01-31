import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import 'package:game_release_calendar/src/domain/enums/release_date_category.dart';
import 'package:game_release_calendar/src/domain/models/release_date.dart';

void main() {
  group('ReleasePrecisionFilter', () {
    group('constructor and properties', () {
      test('should have correct values and display text', () {
        expect(ReleasePrecisionFilter.all.value, equals(0));
        expect(
          ReleasePrecisionFilter.all.displayText,
          equals('All Release Types'),
        );

        expect(ReleasePrecisionFilter.exactDate.value, equals(1));
        expect(
          ReleasePrecisionFilter.exactDate.displayText,
          equals('Exact Dates Only'),
        );

        expect(ReleasePrecisionFilter.yearMonth.value, equals(2));
        expect(
          ReleasePrecisionFilter.yearMonth.displayText,
          equals('Year & Month'),
        );

        expect(ReleasePrecisionFilter.quarter.value, equals(3));
        expect(
          ReleasePrecisionFilter.quarter.displayText,
          equals('Quarters (Q1, Q2, etc.)'),
        );

        expect(ReleasePrecisionFilter.yearOnly.value, equals(4));
        expect(
          ReleasePrecisionFilter.yearOnly.displayText,
          equals('Year Only'),
        );

        expect(ReleasePrecisionFilter.tbd.value, equals(5));
        expect(
          ReleasePrecisionFilter.tbd.displayText,
          equals('To Be Determined'),
        );
      });

      test('should have all enum values', () {
        final values = ReleasePrecisionFilter.values;
        expect(values.length, equals(6));
        expect(values, contains(ReleasePrecisionFilter.all));
        expect(values, contains(ReleasePrecisionFilter.exactDate));
        expect(values, contains(ReleasePrecisionFilter.yearMonth));
        expect(values, contains(ReleasePrecisionFilter.quarter));
        expect(values, contains(ReleasePrecisionFilter.yearOnly));
        expect(values, contains(ReleasePrecisionFilter.tbd));
      });
    });

    group('fromValue', () {
      test('should return correct filter for valid values', () {
        expect(
          ReleasePrecisionFilter.fromValue(0),
          equals(ReleasePrecisionFilter.all),
        );
        expect(
          ReleasePrecisionFilter.fromValue(1),
          equals(ReleasePrecisionFilter.exactDate),
        );
        expect(
          ReleasePrecisionFilter.fromValue(2),
          equals(ReleasePrecisionFilter.yearMonth),
        );
        expect(
          ReleasePrecisionFilter.fromValue(3),
          equals(ReleasePrecisionFilter.quarter),
        );
        expect(
          ReleasePrecisionFilter.fromValue(4),
          equals(ReleasePrecisionFilter.yearOnly),
        );
        expect(
          ReleasePrecisionFilter.fromValue(5),
          equals(ReleasePrecisionFilter.tbd),
        );
      });

      test('should return all filter for invalid values', () {
        expect(
          ReleasePrecisionFilter.fromValue(-1),
          equals(ReleasePrecisionFilter.all),
        );
        expect(
          ReleasePrecisionFilter.fromValue(6),
          equals(ReleasePrecisionFilter.all),
        );
        expect(
          ReleasePrecisionFilter.fromValue(999),
          equals(ReleasePrecisionFilter.all),
        );
      });
    });

    group('matches - robust category resolution', () {
      group('exactDate filter', () {
        test('should match release date with dateFormat 0 (exact)', () {
          final releaseDate = ReleaseDate(
            id: 1,
            date: 1727654400, // Sep 30, 2024
            dateFormat: 0,
            category: null, // Test null category
          );

          expect(ReleasePrecisionFilter.exactDate.matches(releaseDate), isTrue);
        });

        test(
          'should not match release date with dateFormat 1 (year-month)',
          () {
            final releaseDate = ReleaseDate(
              id: 1,
              dateFormat: 1,
              category: null,
            );

            expect(
              ReleasePrecisionFilter.exactDate.matches(releaseDate),
              isFalse,
            );
          },
        );

        test(
          'should match when category is exact even with null dateFormat',
          () {
            final releaseDate = ReleaseDate(
              id: 1,
              category: ReleaseDateCategory.exactDate,
              dateFormat: null,
            );

            expect(
              ReleasePrecisionFilter.exactDate.matches(releaseDate),
              isTrue,
            );
          },
        );
      });

      group('quarter filter', () {
        test('should match release date with human text "Q1 2025"', () {
          final releaseDate = ReleaseDate(
            id: 1,
            human: 'Q1 2025',
            category: null,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match release date with human text "Q4 2025"', () {
          final releaseDate = ReleaseDate(
            id: 1,
            human: 'Q4 2025',
            category: null,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match release date with human text "Quarter 2"', () {
          final releaseDate = ReleaseDate(
            id: 1,
            human: 'Quarter 2',
            category: null,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match release date with human text "quarter 1 2025"', () {
          final releaseDate = ReleaseDate(
            id: 1,
            human: 'quarter 1 2025',
            category: null,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match case insensitive quarter patterns', () {
          final testCases = [
            'q1',
            'Q1',
            'q2 2025',
            'Q3 2025',
            'QUARTER 4',
            'Quarter 1',
          ];

          for (final humanText in testCases) {
            final releaseDate = ReleaseDate(
              id: 1,
              human: humanText,
              category: null,
              dateFormat: null,
            );

            expect(
              ReleasePrecisionFilter.quarter.matches(releaseDate),
              isTrue,
              reason: 'Should match quarter pattern: $humanText',
            );
          }
        });

        test('should not match non-quarter human text', () {
          final nonQuarterTexts = [
            'March 2025',
            'Spring 2025',
            '2025',
            'TBD',
            'Coming Soon',
          ];

          for (final humanText in nonQuarterTexts) {
            final releaseDate = ReleaseDate(
              id: 1,
              human: humanText,
              category: null,
              dateFormat: null,
            );

            expect(
              ReleasePrecisionFilter.quarter.matches(releaseDate),
              isFalse,
              reason: 'Should not match non-quarter text: $humanText',
            );
          }
        });

        test('should match release date with dateFormat 3 (quarter)', () {
          final releaseDate = ReleaseDate(
            id: 1,
            dateFormat: 3,
            category: null,
            human: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match release date with dateFormat 4 (also quarter)', () {
          final releaseDate = ReleaseDate(
            id: 1,
            dateFormat: 4,
            category: null,
            human: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });

        test('should match release date with quarter category', () {
          final releaseDate = ReleaseDate(
            id: 1,
            category: ReleaseDateCategory.quarter,
            dateFormat: null,
            human: null,
          );

          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        });
      });

      group('yearMonth filter', () {
        test('should match release date with dateFormat 1 (year-month)', () {
          final releaseDate = ReleaseDate(id: 1, dateFormat: 1, category: null);

          expect(ReleasePrecisionFilter.yearMonth.matches(releaseDate), isTrue);
        });

        test('should match release date with yearMonth category', () {
          final releaseDate = ReleaseDate(
            id: 1,
            category: ReleaseDateCategory.yearMonth,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.yearMonth.matches(releaseDate), isTrue);
        });
      });

      group('yearOnly filter', () {
        test('should match release date with dateFormat 2 (year)', () {
          final releaseDate = ReleaseDate(id: 1, dateFormat: 2, category: null);

          expect(ReleasePrecisionFilter.yearOnly.matches(releaseDate), isTrue);
        });

        test('should match release date with year category', () {
          final releaseDate = ReleaseDate(
            id: 1,
            category: ReleaseDateCategory.year,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.yearOnly.matches(releaseDate), isTrue);
        });
      });

      group('tbd filter', () {
        test('should match release date with TBD category', () {
          final releaseDate = ReleaseDate(
            id: 1,
            category: ReleaseDateCategory.tbd,
            dateFormat: null,
          );

          expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isTrue);
        });

        test(
          'should match release date with all null fields (fallback to TBD)',
          () {
            final releaseDate = ReleaseDate(
              id: 1,
              category: null,
              dateFormat: null,
              human: null,
            );

            expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isTrue);
          },
        );

        test('should match release date with unknown dateFormat', () {
          final releaseDate = ReleaseDate(
            id: 1,
            dateFormat: 999, // Unknown format
            category: null,
            human: null,
          );

          expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isTrue);
        });
      });

      group('all filter', () {
        test('should match any release date', () {
          final testCases = [
            ReleaseDate(id: 1, dateFormat: 0),
            ReleaseDate(id: 2, dateFormat: 1),
            ReleaseDate(id: 3, human: 'Q1 2025'),
            ReleaseDate(id: 4, category: ReleaseDateCategory.year),
            ReleaseDate(id: 5), // All null
          ];

          for (final releaseDate in testCases) {
            expect(
              ReleasePrecisionFilter.all.matches(releaseDate),
              isTrue,
              reason: 'All filter should match any release date',
            );
          }
        });
      });
    });

    group('priority-based category resolution', () {
      test('human text should take priority over dateFormat', () {
        final releaseDate = ReleaseDate(
          id: 1,
          human: 'Q1 2025', // Should resolve to quarter
          dateFormat: 0, // Would normally be exactDate
          category: null,
        );

        expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
        expect(ReleasePrecisionFilter.exactDate.matches(releaseDate), isFalse);
      });

      test('dateFormat should take priority over category', () {
        final releaseDate = ReleaseDate(
          id: 1,
          human: null,
          dateFormat: 1, // Should resolve to yearMonth
          category:
              ReleaseDateCategory.exactDate, // Would normally be exactDate
        );

        expect(ReleasePrecisionFilter.yearMonth.matches(releaseDate), isTrue);
        expect(ReleasePrecisionFilter.exactDate.matches(releaseDate), isFalse);
      });

      test('category should be used when human and dateFormat are null', () {
        final releaseDate = ReleaseDate(
          id: 1,
          human: null,
          dateFormat: null,
          category: ReleaseDateCategory.year,
        );

        expect(ReleasePrecisionFilter.yearOnly.matches(releaseDate), isTrue);
      });

      test('should fallback to TBD when all fields are null or invalid', () {
        final releaseDate = ReleaseDate(
          id: 1,
          human: null,
          dateFormat: null,
          category: null,
        );

        expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isTrue);
      });
    });

    group('real-world data scenarios', () {
      test(
        'should handle Final Fantasy Tactics scenario (category null, dateFormat 0)',
        () {
          // This represents the real user issue we fixed
          final releaseDate = ReleaseDate(
            id: 716132,
            date: 1727654400, // Sep 30, 2025
            human: 'Sep 30, 2025',
            category: null, // IGDB often has null category
            dateFormat: 0, // But dateFormat indicates exact date
          );

          expect(ReleasePrecisionFilter.exactDate.matches(releaseDate), isTrue);
          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isFalse);
          expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isFalse);
        },
      );

      test(
        'should handle quarter with TBD category but quarter human text',
        () {
          final releaseDate = ReleaseDate(
            id: 1,
            human: 'Q2 2025',
            category: ReleaseDateCategory.tbd, // Wrong category
            dateFormat: 4, // Quarter dateFormat
          );

          // Human text takes priority - should be quarter
          expect(ReleasePrecisionFilter.quarter.matches(releaseDate), isTrue);
          expect(ReleasePrecisionFilter.tbd.matches(releaseDate), isFalse);
        },
      );

      test('should handle complex mixed data from IGDB API', () {
        final testCases = [
          {
            'name': 'Exact date with null category',
            'releaseDate': ReleaseDate(
              id: 1,
              date: 1727654400,
              human: 'Sep 30, 2025',
              category: null,
              dateFormat: 0,
            ),
            'expectedFilter': ReleasePrecisionFilter.exactDate,
          },
          {
            'name': 'Quarter text overrides wrong dateFormat',
            'releaseDate': ReleaseDate(
              id: 2,
              human: 'Q4 2025',
              category: ReleaseDateCategory.tbd,
              dateFormat: 0, // Wrong format
            ),
            'expectedFilter': ReleasePrecisionFilter.quarter,
          },
          {
            'name': 'Year-month from dateFormat with null category',
            'releaseDate': ReleaseDate(
              id: 3,
              human: null,
              category: null,
              dateFormat: 1,
            ),
            'expectedFilter': ReleasePrecisionFilter.yearMonth,
          },
        ];

        for (final testCase in testCases) {
          final releaseDate = testCase['releaseDate'] as ReleaseDate;
          final expectedFilter =
              testCase['expectedFilter'] as ReleasePrecisionFilter;
          final name = testCase['name'] as String;

          expect(
            expectedFilter.matches(releaseDate),
            isTrue,
            reason: 'Test case: $name',
          );
        }
      });
    });

    group('toString', () {
      test('should include value and display text', () {
        final filter = ReleasePrecisionFilter.exactDate;
        final stringOutput = filter.toString();

        expect(stringOutput, contains('value: 1'));
        expect(stringOutput, contains('displayText: Exact Dates Only'));
      });

      test('should work for all enum values', () {
        for (final filter in ReleasePrecisionFilter.values) {
          final stringOutput = filter.toString();
          expect(stringOutput, contains('value: ${filter.value}'));
          expect(stringOutput, contains('displayText: ${filter.displayText}'));
        }
      });
    });
  });
}
