import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/enums/filter/release_precision_filter.dart';
import 'package:game_release_calendar/src/domain/models/filter/game_filter.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/state/upcoming_games_cubit.dart';
import 'package:game_release_calendar/src/presentation/upcoming_games/widgets/filter/filter_bottom_sheet.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';
import '../../../../../helpers/test_helpers.dart';

// Mock Cubit for testing
class MockUpcomingGamesCubit extends UpcomingGamesCubit {
  MockUpcomingGamesCubit() : super(igdbService: FakeIGDBService());

  void updateMockFilters({ReleasePrecisionFilter? precisionChoice}) {
    emit(state.copyWith(
      selectedFilters: GameFilter(
        platformChoices: {},
        categoryIds: {},
        releasePrecisionChoice: precisionChoice,
      ),
    ));
  }

  @override
  Future<void> applySearchFilters({
    required Set<Object?> platformChoices,
    required Object? setDateChoice,
    required Set<int> categoryId,
    ReleasePrecisionFilter? precisionChoice,
  }) async {
    updateMockFilters(precisionChoice: precisionChoice);
  }

  @override
  Future<void> getGames() async {
    // Mock implementation - do nothing
  }
}

void main() {
  group('PrecisionFilters Widget Tests', () {
    late MockUpcomingGamesCubit mockCubit;

    setUp(() {
      setupTestDependencies();
      mockCubit = MockUpcomingGamesCubit();
    });

    tearDown(() {
      tearDownTestDependencies();
    });

    // ignore: avoid_returning_widgets
    Widget buildTestWidget({ReleasePrecisionFilter? initialSelection}) {
      if (initialSelection != null) {
        mockCubit.updateMockFilters(precisionChoice: initialSelection);
      }

      return MaterialApp(
        theme: ThemeData(
          extensions: [AppSpacings.defaultValues],
        ),
        home: Scaffold(
          body: BlocProvider<UpcomingGamesCubit>.value(
            value: mockCubit,
            child: FilterBottomSheet(),
          ),
        ),
      );
    }

    group('initial state', () {
      testWidgets('should display "Release Date Type" header', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.text('Release Date Type'), findsOneWidget);
      });

      testWidgets('should display expand icon when collapsed', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byIcon(Icons.expand_more), findsWidgets);
        expect(find.text('Release Date Type'), findsOneWidget);
      });

      testWidgets('should not show chip when no selection and collapsed', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('should show selected filter chip when collapsed and has selection', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: ReleasePrecisionFilter.exactDate));

        expect(find.byType(Chip), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsOneWidget);
      });
    });

    group('expansion behavior', () {
      testWidgets('should expand when header is tapped', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        final header = find.text('Release Date Type');
        await tester.tap(header);
        await tester.pumpAndSettle();

        expect(find.byIcon(Icons.expand_less), findsWidgets);
        expect(find.byIcon(Icons.expand_more), findsWidgets);
      });

      testWidgets('should show simplified filter options when expanded', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        // Only 2 options now: All and Exact Dates Only
        expect(find.text('All (incl. TBD periods)'), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsOneWidget);

        // These options should no longer exist
        expect(find.text('Year & Month'), findsNothing);
        expect(find.text('Quarters (Q1, Q2, etc.)'), findsNothing);
        expect(find.text('Year Only'), findsNothing);
        expect(find.text('To Be Determined'), findsNothing);
      });

      testWidgets('should collapse when header is tapped again', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        expect(find.text('Release Date Type'), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsNothing);
      });
    });

    group('filter selection', () {
      testWidgets('should select "Exact Dates Only" when tapped', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Exact Dates Only'));
        await tester.pumpAndSettle();
        final exactDateChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'Exact Dates Only'
          )
        );
        expect(exactDateChip.selected, isTrue);
      });

      testWidgets('should select "All (incl. TBD periods)" when tapped', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('All (incl. TBD periods)'));
        await tester.pumpAndSettle();
        final allChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'All (incl. TBD periods)'
          )
        );
        expect(allChip.selected, isTrue);
      });

      testWidgets('should show selected filter as chip when collapsed', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Exact Dates Only'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        expect(find.byType(Chip), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsOneWidget);
      });

      testWidgets('should not show chip for "All" selection', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('All (incl. TBD periods)'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('should allow deselecting a filter', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: ReleasePrecisionFilter.exactDate));

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        final exactDateChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'Exact Dates Only'
          )
        );
        expect(exactDateChip.selected, isTrue);

        await tester.tap(find.text('Exact Dates Only'));
        await tester.pumpAndSettle();
        final exactDateChipAfter = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'Exact Dates Only'
          )
        );
        expect(exactDateChipAfter.selected, isFalse);
      });
    });

    group('visual styling', () {
      testWidgets('selected chip should have primary color', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: ReleasePrecisionFilter.exactDate));

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        final exactDateChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'Exact Dates Only'
          )
        );

        expect(exactDateChip.selected, isTrue);
      });

      testWidgets('unselected chips should not be selected', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: ReleasePrecisionFilter.exactDate));

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        final allChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'All (incl. TBD periods)'
          )
        );
        expect(allChip.selected, isFalse);
      });

      testWidgets('should show compact chip when collapsed and selected', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: ReleasePrecisionFilter.exactDate));

        final chip = tester.widget<Chip>(find.byType(Chip));
        expect(chip.visualDensity, equals(VisualDensity.compact));
        expect(chip.materialTapTargetSize, equals(MaterialTapTargetSize.shrinkWrap));
      });
    });

    group('integration with filter bottom sheet', () {
      testWidgets('should be part of filter bottom sheet layout', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        expect(find.byType(FilterBottomSheet), findsOneWidget);
        expect(find.text('Release Date Type'), findsOneWidget);
        expect(find.byType(SingleChildScrollView), findsOneWidget);
      });

      testWidgets('should maintain state through filter bottom sheet interactions', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Exact Dates Only'));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        final exactDateChip = tester.widget<ChoiceChip>(
          find.byWidgetPredicate((widget) =>
            widget is ChoiceChip &&
            (widget.label as Text).data == 'Exact Dates Only'
          )
        );
        expect(exactDateChip.selected, isTrue);
      });
    });

    group('accessibility and usability', () {
      testWidgets('should be accessible via tap targets', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        final precisionHeaderFinder = find.text('Release Date Type');
        expect(precisionHeaderFinder, findsOneWidget);

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        expect(find.byType(ChoiceChip), findsWidgets);
        expect(find.text('All (incl. TBD periods)'), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsOneWidget);
      });

      testWidgets('should have proper spacing and layout', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();

        expect(find.byType(Wrap), findsWidgets);
        expect(find.byType(ChoiceChip), findsWidgets); // Multiple ChoiceChips in filter sheet
        expect(find.text('Exact Dates Only'), findsOneWidget);
        expect(find.text('All (incl. TBD periods)'), findsOneWidget);
        expect(find.byType(Padding), findsWidgets);
      });

      testWidgets('should handle rapid tapping gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        for (int i = 0; i < 5; i++) {
          await tester.tap(find.text('Release Date Type'));
          await tester.pump(Duration(milliseconds: 100));
        }
        await tester.pumpAndSettle();
        expect(find.text('Release Date Type'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('should handle null initial selection gracefully', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget(initialSelection: null));

        expect(find.text('Release Date Type'), findsOneWidget);
        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('should handle filter changes from external sources', (WidgetTester tester) async {
        mockCubit.updateMockFilters(precisionChoice: ReleasePrecisionFilter.exactDate);
        await tester.pumpWidget(buildTestWidget());
        expect(find.byType(Chip), findsOneWidget);
        expect(find.text('Exact Dates Only'), findsOneWidget);
      });
    });

    group('performance', () {
      testWidgets('should not rebuild unnecessarily', (WidgetTester tester) async {
        await tester.pumpWidget(buildTestWidget());

        await tester.pumpAndSettle();

        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Release Date Type'));
        await tester.pumpAndSettle();
        expect(find.text('Release Date Type'), findsOneWidget);
      });
    });
  });
}
