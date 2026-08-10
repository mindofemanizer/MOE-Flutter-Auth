import 'package:flutter_test/flutter_test.dart';
import 'package:moe_flutter_auth/moe_flutter_auth.dart';

void main() {
  group('UserModel', () {
    test('fromJson parses correctly', () {
      final json = {
        'id': 1,
        'name': 'Test User',
        'email': 'test@example.com',
        'phone': '081234567890',
        'avatar': 'https://example.com/avatar.png',
        'email_verified_at': '2026-08-10T00:00:00.000000Z',
      };

      final user = UserModel.fromJson(json);

      expect(user.id, equals(1));
      expect(user.name, equals('Test User'));
      expect(user.email, equals('test@example.com'));
      expect(user.phone, equals('081234567890'));
      expect(user.avatar, equals('https://example.com/avatar.png'));
      expect(user.isEmailVerified, isTrue);
    });

    test('toJson round-trips correctly', () {
      const user = UserModel(
        id: 1,
        name: 'Test User',
        email: 'test@example.com',
      );

      final json = user.toJson();

      expect(json['id'], equals(1));
      expect(json['name'], equals('Test User'));
      expect(json['email'], equals('test@example.com'));
    });

    test('copyWith updates fields', () {
      const user = UserModel(
        id: 1,
        name: 'Old Name',
        email: 'old@test.com',
      );

      final updated = user.copyWith(name: 'New Name', email: 'new@test.com');

      expect(updated.id, equals(1));
      expect(updated.name, equals('New Name'));
      expect(updated.email, equals('new@test.com'));
    });

    test('isEmailVerified false when null', () {
      const user = UserModel(
        id: 1,
        name: 'Test',
        email: 'test@test.com',
        emailVerifiedAt: null,
      );

      expect(user.isEmailVerified, isFalse);
    });
  });

  group('AuthResponse', () {
    test('fromJson parses correctly', () {
      final json = {
        'token': 'abc123',
        'user': {
          'id': 1,
          'name': 'Test User',
          'email': 'test@example.com',
        },
      };

      final response = AuthResponse.fromJson(json);

      expect(response.token, equals('abc123'));
      expect(response.user.id, equals(1));
      expect(response.user.name, equals('Test User'));
    });
  });

  group('LoginRequest', () {
    test('toJson produces correct map', () {
      const request = LoginRequest(
        email: 'test@test.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['email'], equals('test@test.com'));
      expect(json['password'], equals('password123'));
    });
  });

  group('RegisterRequest', () {
    test('toJson produces correct map', () {
      const request = RegisterRequest(
        name: 'Test User',
        email: 'test@test.com',
        password: 'password123',
      );

      final json = request.toJson();

      expect(json['name'], equals('Test User'));
      expect(json['email'], equals('test@test.com'));
      expect(json['password'], equals('password123'));
    });
  });

  group('MoeAuthConfig', () {
    test('default values', () {
      const config = MoeAuthConfig();

      expect(config.loginEndpoint, equals('/login'));
      expect(config.registerEndpoint, equals('/register'));
      expect(config.meEndpoint, equals('/me'));
      expect(config.tokenKey, equals('auth_token'));
      expect(config.enableOtp, isFalse);
      expect(config.sessionTimeout, equals(const Duration(hours: 24)));
    });

    test('custom values', () {
      const config = MoeAuthConfig(
        loginEndpoint: '/api/auth/login',
        tokenKey: 'custom_token',
        enableOtp: true,
        sessionTimeout: Duration(hours: 1),
      );

      expect(config.loginEndpoint, equals('/api/auth/login'));
      expect(config.tokenKey, equals('custom_token'));
      expect(config.enableOtp, isTrue);
      expect(config.sessionTimeout, equals(const Duration(hours: 1)));
    });
  });
}
