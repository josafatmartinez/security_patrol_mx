import 'package:flutter_test/flutter_test.dart';
import 'package:security_patrol_mx/models/user_model.dart';

void main() {
  group('User Model Tests', () {
    test('User constructor creates instance correctly', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.guard,
      );

      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.role, UserRole.guard);
    });

    test('User.fromJson creates instance correctly', () {
      final json = {
        'id': '1',
        'email': 'test@example.com',
        'name': 'Test User',
        'role': 'guard',
      };

      final user = User.fromJson(json);

      expect(user.id, '1');
      expect(user.email, 'test@example.com');
      expect(user.name, 'Test User');
      expect(user.role, UserRole.guard);
    });

    test('User.fromJson handles different role values', () {
      // Test with committee role
      final committeeJson = {
        'id': '2',
        'email': 'committee@example.com',
        'name': 'Committee User',
        'role': 'committee',
      };
      final committeeUser = User.fromJson(committeeJson);
      expect(committeeUser.role, UserRole.committee);

      // Test with superAdmin role
      final adminJson = {
        'id': '3',
        'email': 'admin@example.com',
        'name': 'Admin User',
        'role': 'superAdmin',
      };
      final adminUser = User.fromJson(adminJson);
      expect(adminUser.role, UserRole.superAdmin);

      // Test with invalid role (should default to guard)
      final invalidJson = {
        'id': '4',
        'email': 'invalid@example.com',
        'name': 'Invalid Role User',
        'role': 'invalid_role',
      };
      final invalidRoleUser = User.fromJson(invalidJson);
      expect(invalidRoleUser.role, UserRole.guard);

      // Test with null role (should default to guard)
      final nullJson = {
        'id': '5',
        'email': 'null@example.com',
        'name': 'Null Role User',
        'role': null,
      };
      final nullRoleUser = User.fromJson(nullJson);
      expect(nullRoleUser.role, UserRole.guard);
    });

    test('User.toJson converts instance to json correctly', () {
      final user = User(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        role: UserRole.committee,
      );

      final json = user.toJson();

      expect(json['id'], '1');
      expect(json['email'], 'test@example.com');
      expect(json['name'], 'Test User');
      expect(json['role'], 'committee');
    });

    test('Role utility methods return correct values', () {
      final guardUser = User(
        id: '1',
        email: 'guard@example.com',
        role: UserRole.guard,
      );

      expect(guardUser.isGuard(), true);
      expect(guardUser.isCommittee(), false);
      expect(guardUser.isSuperAdmin(), false);
      expect(guardUser.canManageUsers(), false);

      final committeeUser = User(
        id: '2',
        email: 'committee@example.com',
        role: UserRole.committee,
      );

      expect(committeeUser.isGuard(), false);
      expect(committeeUser.isCommittee(), true);
      expect(committeeUser.isSuperAdmin(), false);
      expect(committeeUser.canManageUsers(), true);

      final adminUser = User(
        id: '3',
        email: 'admin@example.com',
        role: UserRole.superAdmin,
      );

      expect(adminUser.isGuard(), false);
      expect(adminUser.isCommittee(), false);
      expect(adminUser.isSuperAdmin(), true);
      expect(adminUser.canManageUsers(), true);
    });
  });
}
