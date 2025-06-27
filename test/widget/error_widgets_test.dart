import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/presentation/common/widgets/error_widgets.dart';
import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';

void main() {
  group('Error Widgets', () {
    testWidgets('AppErrorWidget should display error message', (WidgetTester tester) async {
      const exception = NetworkException('Network failed');
      
      await tester.pumpWidget(
        MaterialApp(
          home: AppErrorWidget(
            error: exception,
            title: 'Test Error',
          ),
        ),
      );
      
      expect(find.text('Test Error'), findsOneWidget);
      expect(find.text('Network failed'), findsOneWidget);
      expect(find.byIcon(Icons.error_outline), findsOneWidget);
    });

    testWidgets('AppErrorWidget should show retry button when retryable', (WidgetTester tester) async {
      const exception = NetworkException('Network failed');
      bool retryPressed = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: AppErrorWidget(
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

    testWidgets('AppLoadingWidget should display loading message', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppLoadingWidget(message: 'Loading games...'),
        ),
      );
      
      expect(find.text('Loading games...'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('AppEmptyWidget should display empty state', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppEmptyWidget(
            title: 'No Games',
            message: 'No games found',
          ),
        ),
      );
      
      expect(find.text('No Games'), findsOneWidget);
      expect(find.text('No games found'), findsOneWidget);
      expect(find.byIcon(Icons.inbox), findsOneWidget);
    });
  });
}