import 'package:flutter_test/flutter_test.dart';

import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';

void main() {
  group('App Exceptions', () {
    test('should create network exception with message', () {
      const exception = NetworkException('Network error');

      expect(exception.message, equals('Network error'));
      expect(exception.toString(), equals('Network error'));
    });

    test('should create no internet exception', () {
      const exception = NoInternetException();

      expect(exception.message, equals('No internet connection'));
      expect(exception.toString(), equals('No internet connection'));
    });

    test('should identify retryable exceptions', () {
      const networkException = NetworkException('Error');
      const authException = AuthenticationException('Auth error');
      const timeoutException = TimeoutException();

      expect(ExceptionHandler.isRetryable(networkException), isTrue);
      expect(ExceptionHandler.isRetryable(authException), isFalse);
      expect(ExceptionHandler.isRetryable(timeoutException), isTrue);
    });

    test('should provide user-friendly messages', () {
      const appException = NetworkException('Network error');
      final unknownException = Exception('Unknown');

      expect(ExceptionHandler.getUserMessage(appException),
          equals('Network error'));
      expect(ExceptionHandler.getUserMessage(unknownException),
          equals('Something went wrong. Please try again.'));
    });
  });
}
