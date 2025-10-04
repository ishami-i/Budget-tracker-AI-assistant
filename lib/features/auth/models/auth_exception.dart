/// Custom exception class for authentication-related errors
class AuthException implements Exception {
  final String message;
  final String code;
  final dynamic originalError;

  const AuthException(
    this.message,
    this.code, [
    this.originalError,
  ]);

  /// Common authentication error codes
  static const String emptyFieldsCode = 'EMPTY_FIELDS';
  static const String invalidEmailCode = 'INVALID_EMAIL';
  static const String weakPasswordCode = 'WEAK_PASSWORD';
  static const String passwordMismatchCode = 'PASSWORD_MISMATCH';
  static const String userNotFoundCode = 'USER_NOT_FOUND';
  static const String wrongPasswordCode = 'WRONG_PASSWORD';
  static const String emailAlreadyExistsCode = 'EMAIL_ALREADY_EXISTS';
  static const String networkErrorCode = 'NETWORK_ERROR';
  static const String unknownErrorCode = 'UNKNOWN_ERROR';

  /// Factory constructors for common authentication errors
  factory AuthException.emptyFields() {
    return const AuthException(
      'Please fill in all fields',
      AuthException.emptyFieldsCode,
    );
  }

  factory AuthException.invalidEmail() {
    return const AuthException(
      'Please enter a valid email address',
      AuthException.invalidEmailCode,
    );
  }

  factory AuthException.weakPassword() {
    return const AuthException(
      'Password must be at least 6 characters long',
      AuthException.weakPasswordCode,
    );
  }

  factory AuthException.passwordMismatch() {
    return const AuthException(
      'Passwords do not match',
      AuthException.passwordMismatchCode,
    );
  }

  factory AuthException.userNotFound() {
    return const AuthException(
      'No user found with this email address',
      AuthException.userNotFoundCode,
    );
  }

  factory AuthException.wrongPassword() {
    return const AuthException(
      'Incorrect password',
      AuthException.wrongPasswordCode,
    );
  }

  factory AuthException.emailAlreadyExists() {
    return const AuthException(
      'An account with this email already exists',
      AuthException.emailAlreadyExistsCode,
    );
  }

  factory AuthException.networkError() {
    return const AuthException(
      'Network error. Please check your connection and try again',
      AuthException.networkErrorCode,
    );
  }

  factory AuthException.unknown([dynamic originalError]) {
    return AuthException(
      'An unexpected error occurred',
      AuthException.unknownErrorCode,
      originalError,
    );
  }

  @override
  String toString() {
    return 'AuthException(message: $message, code: $code, originalError: $originalError)';
  }
}