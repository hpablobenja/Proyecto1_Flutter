/// Base abstract class for all custom exceptions in the application.
abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);

  @override
  String toString() {
    return message;
  }
}

/// Exception thrown when a requested resource is not found.
class NotFoundException extends AppException {
  NotFoundException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}

/// Exception thrown for database-related errors.
class DatabaseException extends AppException {
  final dynamic originalError; // Optional: to store the original database error

  DatabaseException(
    String message, [
    this.originalError,
    StackTrace? stackTrace,
  ]) : super(message, stackTrace);

  // Helper to check for specific database error types, like unique constraint
  bool isUniqueConstraintError() {
    // This is a basic check. You might need to refine it based on the actual
    // error messages from your specific database implementation (e.g., sqflite).
    final errorString =
        originalError?.toString().toLowerCase() ?? message.toLowerCase();
    return errorString.contains('unique constraint failed') ||
        errorString.contains('already exists');
  }

  @override
  String toString() {
    return 'DatabaseException: $message${originalError != null ? ' ($originalError)' : ''}';
  }
}

/// Exception thrown for authentication or authorization errors.
class AuthenticationException extends AppException {
  AuthenticationException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}

/// Exception thrown when there is a conflict, e.g., trying to create a resource
/// that already exists with a unique identifier.
class ConflictException extends AppException {
  ConflictException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}

/// Exception thrown for validation errors.
class ValidationException extends AppException {
  ValidationException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}

/// Exception thrown for network-related errors.
class NetworkException extends AppException {
  NetworkException(String message, [StackTrace? stackTrace])
    : super(message, stackTrace);
}
