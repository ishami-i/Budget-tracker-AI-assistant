import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('returns error when null or empty', () {
      expect(Validators.email(null), 'Email is required');
      expect(Validators.email(''), 'Email is required');
    });

    test('returns error for invalid email', () {
      expect(
        Validators.email('not-an-email'),
        'Please enter a valid email address',
      );
    });

    test('returns null for valid email', () {
      expect(Validators.email('a@b.com'), isNull);
    });
  });

  group('Validators.password', () {
    test('returns error when null or empty', () {
      expect(Validators.password(null), 'Password is required');
      expect(Validators.password(''), 'Password is required');
    });

    test('returns error when too short', () {
      expect(
        Validators.password('12345'),
        'Password must be at least 6 characters',
      );
    });

    test('returns null for valid password', () {
      expect(Validators.password('123456'), isNull);
    });
  });

  group('Validators.required', () {
    test('returns error with default field name', () {
      expect(Validators.required(null), 'This field is required');
    });

    test('returns error with custom field name', () {
      expect(Validators.required('', 'Email'), 'Email is required');
    });

    test('returns null when value present', () {
      expect(Validators.required('x'), isNull);
    });
  });

  group('Validators.confirmPassword', () {
    test('returns error when null or empty', () {
      expect(
        Validators.confirmPassword(null, 'pass'),
        'Please confirm your password',
      );
      expect(
        Validators.confirmPassword('', 'pass'),
        'Please confirm your password',
      );
    });

    test('returns error when mismatch', () {
      expect(
        Validators.confirmPassword('abc', 'def'),
        'Passwords do not match',
      );
    });

    test('returns null when match', () {
      expect(Validators.confirmPassword('same', 'same'), isNull);
    });
  });

  group('Validators.name', () {
    test('returns error when null or empty', () {
      expect(Validators.name(null), 'Name is required');
      expect(Validators.name(''), 'Name is required');
    });

    test('returns error when too short', () {
      expect(Validators.name('A'), 'Name must be at least 2 characters');
    });

    test('returns null for valid name', () {
      expect(Validators.name('Al'), isNull);
    });
  });
}
