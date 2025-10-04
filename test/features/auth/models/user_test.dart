import 'package:flutter_test/flutter_test.dart';
import 'package:smartbudget_ai/features/auth/models/user.dart';

void main() {
  group('User Model Tests', () {
    final testDateTime = DateTime(2024, 1, 15, 10, 30, 0);
    final testUser = User(
      id: 'user_123',
      email: 'test@example.com',
      name: 'Test User',
      createdAt: testDateTime,
      updatedAt: testDateTime,
    );

    group('Constructor', () {
      test('should create user with all required fields', () {
        final user = User(
          id: 'user_123',
          email: 'test@example.com',
          createdAt: testDateTime,
        );

        expect(user.id, equals('user_123'));
        expect(user.email, equals('test@example.com'));
        expect(user.name, isNull);
        expect(user.createdAt, equals(testDateTime));
        expect(user.updatedAt, isNull);
      });

      test('should create user with optional fields', () {
        expect(testUser.id, equals('user_123'));
        expect(testUser.email, equals('test@example.com'));
        expect(testUser.name, equals('Test User'));
        expect(testUser.createdAt, equals(testDateTime));
        expect(testUser.updatedAt, equals(testDateTime));
      });
    });

    group('fromJson', () {
      test('should create user from valid JSON with all fields', () {
        final json = {
          'id': 'user_123',
          'email': 'test@example.com',
          'name': 'Test User',
          'createdAt': testDateTime.toIso8601String(),
          'updatedAt': testDateTime.toIso8601String(),
        };

        final user = User.fromJson(json);

        expect(user.id, equals('user_123'));
        expect(user.email, equals('test@example.com'));
        expect(user.name, equals('Test User'));
        expect(user.createdAt, equals(testDateTime));
        expect(user.updatedAt, equals(testDateTime));
      });

      test('should create user from JSON with null optional fields', () {
        final json = {
          'id': 'user_123',
          'email': 'test@example.com',
          'name': null,
          'createdAt': testDateTime.toIso8601String(),
          'updatedAt': null,
        };

        final user = User.fromJson(json);

        expect(user.id, equals('user_123'));
        expect(user.email, equals('test@example.com'));
        expect(user.name, isNull);
        expect(user.createdAt, equals(testDateTime));
        expect(user.updatedAt, isNull);
      });

      test('should throw when required fields are missing', () {
        final json = {
          'email': 'test@example.com',
          'createdAt': testDateTime.toIso8601String(),
        };

        expect(() => User.fromJson(json), throwsA(isA<TypeError>()));
      });
    });

    group('toJson', () {
      test('should convert user to JSON with all fields', () {
        final json = testUser.toJson();

        expect(json['id'], equals('user_123'));
        expect(json['email'], equals('test@example.com'));
        expect(json['name'], equals('Test User'));
        expect(json['createdAt'], equals(testDateTime.toIso8601String()));
        expect(json['updatedAt'], equals(testDateTime.toIso8601String()));
      });

      test('should convert user to JSON with null fields', () {
        final user = User(
          id: 'user_123',
          email: 'test@example.com',
          createdAt: testDateTime,
        );

        final json = user.toJson();

        expect(json['id'], equals('user_123'));
        expect(json['email'], equals('test@example.com'));
        expect(json['name'], isNull);
        expect(json['createdAt'], equals(testDateTime.toIso8601String()));
        expect(json['updatedAt'], isNull);
      });
    });

    group('copyWith', () {
      test('should create copy with updated fields', () {
        final updatedUser = testUser.copyWith(
          name: 'Updated Name',
          email: 'updated@example.com',
        );

        expect(updatedUser.id, equals(testUser.id));
        expect(updatedUser.email, equals('updated@example.com'));
        expect(updatedUser.name, equals('Updated Name'));
        expect(updatedUser.createdAt, equals(testUser.createdAt));
        expect(updatedUser.updatedAt, equals(testUser.updatedAt));
      });

      test('should create copy with same values when no changes', () {
        final copiedUser = testUser.copyWith();

        expect(copiedUser.id, equals(testUser.id));
        expect(copiedUser.email, equals(testUser.email));
        expect(copiedUser.name, equals(testUser.name));
        expect(copiedUser.createdAt, equals(testUser.createdAt));
        expect(copiedUser.updatedAt, equals(testUser.updatedAt));
      });
    });

    group('Equality and HashCode', () {
      test('should be equal when all fields match', () {
        final user1 = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        final user2 = User(
          id: 'user_123',
          email: 'test@example.com',
          name: 'Test User',
          createdAt: testDateTime,
          updatedAt: testDateTime,
        );

        expect(user1, equals(user2));
        expect(user1.hashCode, equals(user2.hashCode));
      });

      test('should not be equal when fields differ', () {
        final user1 = User(
          id: 'user_123',
          email: 'test@example.com',
          createdAt: testDateTime,
        );

        final user2 = User(
          id: 'user_456',
          email: 'test@example.com',
          createdAt: testDateTime,
        );

        expect(user1, isNot(equals(user2)));
        expect(user1.hashCode, isNot(equals(user2.hashCode)));
      });
    });

    group('toString', () {
      test('should return string representation', () {
        final userString = testUser.toString();

        expect(userString, contains('User('));
        expect(userString, contains('id: user_123'));
        expect(userString, contains('email: test@example.com'));
        expect(userString, contains('name: Test User'));
      });
    });
  });
}