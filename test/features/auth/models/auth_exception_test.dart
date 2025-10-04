import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/auth/models/auth_exception.dart';

void main() {
  group('AuthException Tests', () {
    group('Constructor', () {
      test('should create exception with message and code', () {
        const exception = AuthException('Test message', 'TEST_CODE');

        expect(exception.message, equals('Test message'));
        expect(exception.code, equals('TEST_CODE'));
        expect(exception.originalError, isNull);
      });

      test('should create exception with original error', () {
        final originalError = Exception('Original error');
        final exception = AuthException(
          'Test message',
          'TEST_CODE',
          originalError,
        );

        expect(exception.message, equals('Test message'));
        expect(exception.code, equals('TEST_CODE'));
        expect(exception.originalError, equals(originalError));
      });
    });

    group('Factory Constructors', () {
      test('emptyFields should create correct exception', () {
        final exception = AuthException.emptyFields();

        expect(exception.message, equals('Please fill in all fields'));
        expect(exception.code, equals(AuthException.emptyFieldsCode));
        expect(exception.originalError, isNull);
      });

      test('invalidEmail should create correct exception', () {
        final exception = AuthException.invalidEmail();

        expect(exception.message, equals('Please enter a valid email address'));
        expect(exception.code, equals(AuthException.invalidEmailCode));
        expect(exception.originalError, isNull);
      });

      test('weakPassword should create correct exception', () {
        final exception = AuthException.weakPassword();

        expect(exception.message, equals('Password must be at least 6 characters long'));
        expect(exception.code, equals(AuthException.weakPasswordCode));
        expect(exception.originalError, isNull);
      });

      test('passwordMismatch should create correct exception', () {
        final exception = AuthException.passwordMismatch();

        expect(exception.message, equals('Passwords do not match'));
        expect(exception.code, equals(AuthException.passwordMismatchCode));
        expect(exception.originalError, isNull);
      });

      test('userNotFound should create correct exception', () {
        final exception = AuthException.userNotFound();

        expect(exception.message, equals('No user found with this email address'));
        expect(exception.code, equals(AuthException.userNotFoundCode));
        expect(exception.originalError, isNull);
      });

      test('wrongPassword should create correct exception', () {
        final exception = AuthException.wrongPassword();

        expect(exception.message, equals('Incorrect password'));
        expect(exception.code, equals(AuthException.wrongPasswordCode));
        expect(exception.originalError, isNull);
      });

      test('emailAlreadyExists should create correct exception', () {
        final exception = AuthException.emailAlreadyExists();

        expect(exception.message, equals('An account with this email already exists'));
        expect(exception.code, equals(AuthException.emailAlreadyExistsCode));
        expect(exception.originalError, isNull);
      });

      test('networkError should create correct exception', () {
        final exception = AuthException.networkError();

        expect(exception.message, equals('Network error. Please check your connection and try again'));
        expect(exception.code, equals(AuthException.networkErrorCode));
        expect(exception.originalError, isNull);
      });

      test('unknown should create correct exception without original error', () {
        final exception = AuthException.unknown();

        expect(exception.message, equals('An unexpected error occurred'));
        expect(exception.code, equals(AuthException.unknownErrorCode));
        expect(exception.originalError, isNull);
      });

      test('unknown should create correct exception with original error', () {
        final originalError = Exception('Original error');
        final exception = AuthException.unknown(originalError);

        expect(exception.message, equals('An unexpected error occurred'));
        expect(exception.code, equals(AuthException.unknownErrorCode));
        expect(exception.originalError, equals(originalError));
      });
    });

    group('Error Codes', () {
      test('should have correct error code constants', () {
        expect(AuthException.emptyFieldsCode, equals('EMPTY_FIELDS'));
        expect(AuthException.invalidEmailCode, equals('INVALID_EMAIL'));
        expect(AuthException.weakPasswordCode, equals('WEAK_PASSWORD'));
        expect(AuthException.passwordMismatchCode, equals('PASSWORD_MISMATCH'));
        expect(AuthException.userNotFoundCode, equals('USER_NOT_FOUND'));
        expect(AuthException.wrongPasswordCode, equals('WRONG_PASSWORD'));
        expect(AuthException.emailAlreadyExistsCode, equals('EMAIL_ALREADY_EXISTS'));
        expect(AuthException.networkErrorCode, equals('NETWORK_ERROR'));
        expect(AuthException.unknownErrorCode, equals('UNKNOWN_ERROR'));
      });
    });

    group('toString', () {
      test('should return string representation without original error', () {
        const exception = AuthException('Test message', 'TEST_CODE');
        final exceptionString = exception.toString();

        expect(exceptionString, contains('AuthException('));
        expect(exceptionString, contains('message: Test message'));
        expect(exceptionString, contains('code: TEST_CODE'));
        expect(exceptionString, contains('originalError: null'));
      });

      test('should return string representation with original error', () {
        final originalError = Exception('Original error');
        final exception = AuthException('Test message', 'TEST_CODE', originalError);
        final exceptionString = exception.toString();

        expect(exceptionString, contains('AuthException('));
        expect(exceptionString, contains('message: Test message'));
        expect(exceptionString, contains('code: TEST_CODE'));
        expect(exceptionString, contains('originalError: Exception: Original error'));
      });
    });
  });
}