import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/auth/services/auth_service.dart';
import 'package:smartbudget_ai/features/auth/models/auth_exception.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
    authService.clearUsers();
  });

  group('AuthService signUp', () {
    test('creates a new user successfully', () async {
      final user = await authService.signUp(
        'user@example.com',
        'secret6',
        name: 'User',
      );
      expect(user.email, 'user@example.com');
      expect(authService.userExists('user@example.com'), isTrue);
      expect(authService.userCount, 1);
    });

    test('throws when email already exists', () async {
      await authService.signUp('dup@example.com', 'secret6');
      expect(
        () => authService.signUp('dup@example.com', 'secret6'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.emailAlreadyExistsCode,
          ),
        ),
      );
    });

    test('throws on weak password', () async {
      expect(
        () => authService.signUp('weak@example.com', '123'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.weakPasswordCode,
          ),
        ),
      );
    });

    test('throws on invalid email', () async {
      expect(
        () => authService.signUp('not-email', 'secret6'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.invalidEmailCode,
          ),
        ),
      );
    });

    test('signUpWithConfirmation throws on mismatch', () async {
      expect(
        () =>
            authService.signUpWithConfirmation('x@y.com', 'secret6', 'secret7'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.passwordMismatchCode,
          ),
        ),
      );
    });
  });

  group('AuthService signIn', () {
    test('signs in existing user successfully', () async {
      await authService.signUp('login@example.com', 'secret6', name: 'Login');
      final user = await authService.signIn('login@example.com', 'secret6');
      expect(user.email, 'login@example.com');
    });

    test('throws user not found', () async {
      expect(
        () => authService.signIn('missing@example.com', 'secret6'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.userNotFoundCode,
          ),
        ),
      );
    });

    test('throws wrong password', () async {
      await authService.signUp('pw@example.com', 'secret6');
      expect(
        () => authService.signIn('pw@example.com', 'badpass'),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.wrongPasswordCode,
          ),
        ),
      );
    });

    test('throws on empty fields', () async {
      expect(
        () => authService.signIn('', ''),
        throwsA(
          isA<AuthException>().having(
            (e) => e.code,
            'code',
            AuthException.emptyFieldsCode,
          ),
        ),
      );
    });
  });
}
