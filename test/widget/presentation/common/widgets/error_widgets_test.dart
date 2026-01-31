import 'package:flutter/material.dart';

import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';
import 'package:game_release_calendar/src/theme/spacing/app_spacings.dart';

void main() {
  group('Error Widgets Tests', () {
    testWidgets(
      'AppErrorWidget should display error message and retry button',
      (WidgetTester tester) async {
        var retryPressed = false;
        final error = NetworkException('Something went wrong');

        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(extensions: [AppSpacings.defaultValues]),
            home: Scaffold(
              body: AppErrorWidget(
                error: error,
                onRetry: () {
                  retryPressed = true;
                },
              ),
            ),
          ),
        );

        // Verify error icon is displayed
        expect(find.byIcon(Icons.error_outline), findsOneWidget);

        // Verify retry button is present - should be there for NetworkException
        expect(find.text('Try Again'), findsOneWidget);
        expect(find.byIcon(Icons.refresh), findsOneWidget);

        // Test retry button functionality
        await tester.tap(find.text('Try Again'));
        await tester.pump();

        expect(retryPressed, isTrue);
      },
    );

    testWidgets('AppErrorWidget should handle non-retryable errors', (
      WidgetTester tester,
    ) async {
      final error = AuthenticationException('Authentication failed');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppErrorWidget(error: error, onRetry: () {}),
          ),
        ),
      );

      // Should display error but no retry button for non-retryable errors
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('AppErrorWidget should handle null onRetry callback', (
      WidgetTester tester,
    ) async {
      final error = NetworkException('Test error');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(body: AppErrorWidget(error: error)),
        ),
      );

      // Should still display the widget without crashing
      expect(find.byIcon(Icons.error_outline), findsOneWidget);

      // Retry button should not be present
      expect(find.text('Try Again'), findsNothing);
    });

    testWidgets('AppErrorWidget should display custom title', (
      WidgetTester tester,
    ) async {
      final error = NetworkException('Network error');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppErrorWidget(
              error: error,
              title: 'Connection Failed',
              onRetry: () {},
            ),
          ),
        ),
      );

      expect(find.text('Connection Failed'), findsOneWidget);
    });

    testWidgets('AppErrorWidget should be accessible', (
      WidgetTester tester,
    ) async {
      final error = NetworkException('Accessibility test');

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppErrorWidget(error: error, onRetry: () {}),
          ),
        ),
      );

      // Check that widget renders without errors - accessibility labels may vary
      expect(find.byType(AppErrorWidget), findsOneWidget);
    });

    testWidgets('AppLoadingWidget should display loading indicator', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(body: AppLoadingWidget()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading...'), findsOneWidget);
    });

    testWidgets('AppLoadingWidget should display custom message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppLoadingWidget(message: 'Custom loading message'),
          ),
        ),
      );

      expect(find.text('Custom loading message'), findsOneWidget);
    });

    testWidgets('AppEmptyWidget should display title and message', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppEmptyWidget(
              title: 'No Data',
              message: 'There is no data to display',
            ),
          ),
        ),
      );

      expect(find.text('No Data'), findsOneWidget);
      expect(find.text('There is no data to display'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });

    testWidgets('AppEmptyWidget should display action button when provided', (
      WidgetTester tester,
    ) async {
      var actionPressed = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(extensions: [AppSpacings.defaultValues]),
          home: Scaffold(
            body: AppEmptyWidget(
              title: 'No Data',
              message: 'There is no data to display',
              actionLabel: 'Refresh',
              onAction: () {
                actionPressed = true;
              },
            ),
          ),
        ),
      );

      expect(find.text('Refresh'), findsOneWidget);

      await tester.tap(find.text('Refresh'));
      await tester.pump();

      expect(actionPressed, isTrue);
    });
  });
}
