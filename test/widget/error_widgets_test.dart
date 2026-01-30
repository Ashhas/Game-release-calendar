import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

void main() {
  group('Error Widgets', () {
    // ignore: avoid_returning_widgets
    Widget createTestWidget({required Widget child}) {
      return MaterialApp(
        theme: ThemeData(
          extensions: [
            AppSpacings.defaultValues,
          ],
        ),
        home: child,
      );
    }

    testWidgets('AppErrorWidget should display error message',
        (WidgetTester tester) async {
      const exception = NetworkException('Network failed');

      await tester.pumpWidget(
        createTestWidget(
          child: AppErrorWidget(
            error: exception,
            title: 'Test Error',
          ),
        ),
      );

      expect(find.text('Test Error'), findsOneWidget);
      expect(find.text('Network failed'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('AppErrorWidget should show retry button when retryable',
        (WidgetTester tester) async {
      const exception = NetworkException('Network failed');
      bool retryPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: AppErrorWidget(
            error: exception,
            onRetry: () => retryPressed = true,
          ),
        ),
      );

      expect(find.text('Try Again'), findsOneWidget);

      await tester.tap(find.text('Try Again'));
      await tester.pump();

      expect(retryPressed, isTrue);
    });

    testWidgets('AppLoadingWidget should display loading message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppLoadingWidget(message: 'Loading games...'),
        ),
      );

      expect(find.text('Loading games...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppEmptyWidget should display empty state',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppEmptyWidget(
            title: 'No Games',
            message: 'No games found',
          ),
        ),
      );

      expect(find.text('No Games'), findsOneWidget);
      expect(find.text('No games found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('AppErrorWidget should handle non-retryable errors',
        (WidgetTester tester) async {
      const exception = NetworkException('Generic error');

      await tester.pumpWidget(
        createTestWidget(
          child: AppErrorWidget(
            error: exception,
            title: 'Fatal Error',
          ),
        ),
      );

      expect(find.text('Fatal Error'), findsOneWidget);
      expect(find.text('Generic error'), findsOneWidget);
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('AppErrorWidget should handle null retry callback',
        (WidgetTester tester) async {
      const exception = NetworkException('Network failed');

      await tester.pumpWidget(
        createTestWidget(
          child: AppErrorWidget(
            error: exception,
            onRetry: null,
          ),
        ),
      );

      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('AppLoadingWidget should handle null message',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppLoadingWidget(),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppEmptyWidget should handle optional action button',
        (WidgetTester tester) async {
      bool actionPressed = false;

      await tester.pumpWidget(
        createTestWidget(
          child: AppEmptyWidget(
            title: 'No Items',
            message: 'Nothing here',
            actionLabel: 'Refresh',
            onAction: () => actionPressed = true,
          ),
        ),
      );

      expect(find.text('Refresh'), findsOneWidget);

      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(actionPressed, isTrue);
    });

    testWidgets('AppEmptyWidget should work without action',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        createTestWidget(
          child: const AppEmptyWidget(
            title: 'Empty',
            message: 'Nothing to show',
          ),
        ),
      );

      expect(find.text('Empty'), findsOneWidget);
      expect(find.text('Nothing to show'), findsOneWidget);
    });
  });
}
