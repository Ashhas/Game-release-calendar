import 'package:flutter_test/flutter_test.dart';
import 'package:game_release_calendar/src/utils/retry_helper.dart';
import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';

void main() {
  group('RetryHelper', () {
    test('should succeed on first attempt', () async {
      int callCount = 0;
      
      final result = await RetryHelper.retry(() async {
        callCount++;
        return 'success';
      });
      
      expect(result, equals('success'));
      expect(callCount, equals(1));
    });

    test('should retry on network failure and eventually succeed', () async {
      int callCount = 0;
      
      final result = await RetryHelper.retry(() async {
        callCount++;
        if (callCount < 3) {
          throw const NetworkException('Network failed');
        }
        return 'success';
      });
      
      expect(result, equals('success'));
      expect(callCount, equals(3));
    });

    test('should not retry on authentication exception', () async {
      int callCount = 0;
      
      try {
        await RetryHelper.retry(() async {
          callCount++;
          throw const AuthenticationException('Auth failed');
        });
        fail('Should have thrown exception');
      } catch (e) {
        expect(e, isA<AuthenticationException>());
        expect(callCount, equals(1)); // Should not retry
      }
    });

    test('should not retry on no internet exception', () async {
      int callCount = 0;
      
      try {
        await RetryHelper.retry(() async {
          callCount++;
          throw const NoInternetException();
        });
        fail('Should have thrown exception');
      } catch (e) {
        expect(e, isA<NoInternetException>());
        expect(callCount, equals(1)); // Should not retry
      }
    });

    test('should respect max retries limit', () async {
      int callCount = 0;
      
      try {
        await RetryHelper.retry(
          () async {
            callCount++;
            throw const NetworkException('Always fails');
          },
          maxRetries: 2,
        );
        fail('Should have thrown exception');
      } catch (e) {
        expect(e, isA<NetworkException>());
        expect(callCount, equals(3)); // Initial attempt + 2 retries
      }
    });
  });
}