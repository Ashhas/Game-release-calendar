import 'dart:async';

import 'package:game_release_calendar/src/domain/exceptions/app_exceptions.dart';

class RetryHelper {
  static Future<T> retry<T>(
    Future<T> Function() operation, {
    int maxRetries = 2,
  }) async {
    Exception? lastException;

    for (int attempt = 0; attempt <= maxRetries; attempt++) {
      try {
        return await operation();
      } catch (e) {
        lastException = e is Exception ? e : Exception(e.toString());

        if (attempt >= maxRetries) break;

        // Don't retry authentication errors or no internet
        if (lastException is AuthenticationException ||
            lastException is NoInternetException) break;

        // Wait before retry
        await Future.delayed(Duration(seconds: attempt + 1));
      }
    }

    throw lastException ?? Exception('Operation failed');
  }
}
