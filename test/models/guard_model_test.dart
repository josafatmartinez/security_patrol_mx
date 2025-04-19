import 'package:flutter_test/flutter_test.dart';
import 'package:security_patrol_mx/models/guard_model.dart';

void main() {
  group('Guard Model Tests', () {
    test('Guard constructor creates instance correctly', () {
      final DateTime now = DateTime.now();
      final guard = Guard(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        profileImage: 'profile.jpg',
        isActive: true,
        lastCheckpoint: 'Entrada Principal',
        lastActivity: now,
      );

      expect(guard.id, '1');
      expect(guard.name, 'John Doe');
      expect(guard.email, 'john@example.com');
      expect(guard.phone, '1234567890');
      expect(guard.profileImage, 'profile.jpg');
      expect(guard.isActive, true);
      expect(guard.lastCheckpoint, 'Entrada Principal');
      expect(guard.lastActivity, now);
    });

    test('Guard constructor uses default values', () {
      final guard = Guard(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
      );

      expect(guard.id, '1');
      expect(guard.name, 'John Doe');
      expect(guard.email, 'john@example.com');
      expect(guard.phone, '1234567890');
      expect(guard.profileImage, null);
      expect(guard.isActive, true); // default value
      expect(guard.lastCheckpoint, null);
      expect(guard.lastActivity, null);
    });

    test('Guard.fromJson creates instance correctly', () {
      final now = DateTime.now();
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '1234567890',
        'profileImage': 'profile.jpg',
        'isActive': true,
        'lastCheckpoint': 'Entrada Principal',
        'lastActivity': now.toIso8601String(),
      };

      final guard = Guard.fromJson(json);

      expect(guard.id, '1');
      expect(guard.name, 'John Doe');
      expect(guard.email, 'john@example.com');
      expect(guard.phone, '1234567890');
      expect(guard.profileImage, 'profile.jpg');
      expect(guard.isActive, true);
      expect(guard.lastCheckpoint, 'Entrada Principal');
      expect(guard.lastActivity?.toIso8601String(), now.toIso8601String());
    });

    test('Guard.fromJson handles missing optional values', () {
      final json = {
        'id': '1',
        'name': 'John Doe',
        'email': 'john@example.com',
        'phone': '1234567890',
      };

      final guard = Guard.fromJson(json);

      expect(guard.id, '1');
      expect(guard.name, 'John Doe');
      expect(guard.email, 'john@example.com');
      expect(guard.phone, '1234567890');
      expect(guard.profileImage, null);
      expect(guard.isActive, true); // Should use default
      expect(guard.lastCheckpoint, null);
      expect(guard.lastActivity, null);
    });

    test('Guard.toJson converts instance to json correctly', () {
      final now = DateTime.now();
      final guard = Guard(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
        profileImage: 'profile.jpg',
        isActive: true,
        lastCheckpoint: 'Entrada Principal',
        lastActivity: now,
      );

      final json = guard.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '1234567890');
      expect(json['profileImage'], 'profile.jpg');
      expect(json['isActive'], true);
      expect(json['lastCheckpoint'], 'Entrada Principal');
      expect(json['lastActivity'], now.toIso8601String());
    });

    test('Guard.toJson handles null values', () {
      final guard = Guard(
        id: '1',
        name: 'John Doe',
        email: 'john@example.com',
        phone: '1234567890',
      );

      final json = guard.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'John Doe');
      expect(json['email'], 'john@example.com');
      expect(json['phone'], '1234567890');
      expect(json['profileImage'], null);
      expect(json['isActive'], true);
      expect(json['lastCheckpoint'], null);
      expect(json['lastActivity'], null);
    });
  });
}
