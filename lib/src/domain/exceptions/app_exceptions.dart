abstract class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException(super.message);
}

class NoInternetException extends NetworkException {
  const NoInternetException() : super('No internet connection');
}

class TimeoutException extends NetworkException {
  const TimeoutException() : super('Request timed out');
}

class ServerException extends NetworkException {
  const ServerException(String message) : super(message);
}

class AuthenticationException extends AppException {
  const AuthenticationException(super.message);
}

class TokenExpiredException extends AuthenticationException {
  const TokenExpiredException() : super('Session expired');
}

class ParseException extends AppException {
  const ParseException(super.message);
}

class ApiException extends AppException {
  const ApiException(super.message, [this.statusCode]);
  final int? statusCode;
}

class RateLimitException extends ApiException {
  const RateLimitException() : super('Too many requests', 429);
}

class ExceptionHandler {
  static String getUserMessage(Exception exception) {
    if (exception is AppException) {
      return exception.message;
    }
    return 'Something went wrong. Please try again.';
  }

  static bool isRetryable(Exception exception) {
    return exception is NetworkException && exception is! AuthenticationException;
  }
}