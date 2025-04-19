import 'package:flutter_test/flutter_test.dart';
import 'package:security_patrol_mx/models/user_model.dart';
import 'package:security_patrol_mx/services/auth_service.dart';

void main() {
  late AuthService authService;

  setUp(() {
    authService = AuthService();
  });

  group('AuthService Login Tests', () {
    test(
      'login with valid committee credentials returns user with committee role',
      () async {
        final user = await authService.login('admin@example.com', 'admin123');

        expect(user, isNotNull);
        expect(user?.email, 'admin@example.com');
        expect(user?.role, UserRole.committee);
        expect(user?.name, 'Admin User');
      },
    );

    test(
      'login with valid guard credentials returns user with guard role',
      () async {
        final user = await authService.login('guard@example.com', 'guard123');

        expect(user, isNotNull);
        expect(user?.email, 'guard@example.com');
        expect(user?.role, UserRole.guard);
        expect(user?.name, 'Guard User');
      },
    );

    test('login with valid test credentials returns default user', () async {
      final user = await authService.login('test@example.com', 'password123');

      expect(user, isNotNull);
      expect(user?.email, 'test@example.com');
      expect(user?.role, UserRole.guard); // Default role is guard
      expect(user?.name, 'Test User');
    });

    test('login with invalid credentials throws exception', () async {
      expect(
        () => authService.login('invalid@example.com', 'invalidpassword'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Invalid credentials'),
          ),
        ),
      );
    });

    test('login with empty email throws exception', () async {
      expect(
        () => authService.login('', 'password123'),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email and password are required'),
          ),
        ),
      );
    });

    test('login with empty password throws exception', () async {
      expect(
        () => authService.login('test@example.com', ''),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Email and password are required'),
          ),
        ),
      );
    });
  });

  group('AuthService Register Tests', () {
    test(
      'register with valid data and committee user returns new user',
      () async {
        final currentUser = User(
          id: '1',
          email: 'admin@example.com',
          name: 'Admin User',
          role: UserRole.committee,
        );

        final newUser = await authService.register(
          'New User',
          'new@example.com',
          'password123',
          role: UserRole.guard,
          currentUser: currentUser,
        );

        expect(newUser, isNotNull);
        expect(newUser?.email, 'new@example.com');
        expect(newUser?.name, 'New User');
        expect(newUser?.role, UserRole.guard);
      },
    );

    test(
      'register with valid data and superAdmin user returns new user',
      () async {
        final currentUser = User(
          id: '1',
          email: 'admin@example.com',
          name: 'Super Admin',
          role: UserRole.superAdmin,
        );

        final newUser = await authService.register(
          'New User',
          'new@example.com',
          'password123',
          role: UserRole.committee,
          currentUser: currentUser,
        );

        expect(newUser, isNotNull);
        expect(newUser?.email, 'new@example.com');
        expect(newUser?.name, 'New User');
        expect(newUser?.role, UserRole.committee);
      },
    );

    test('register with non-admin user throws permission exception', () async {
      final currentUser = User(
        id: '2',
        email: 'guard@example.com',
        name: 'Guard User',
        role: UserRole.guard,
      );

      expect(
        () => authService.register(
          'New User',
          'new@example.com',
          'password123',
          currentUser: currentUser,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('No tienes permisos para registrar nuevos usuarios'),
          ),
        ),
      );
    });

    test('register with empty name throws exception', () async {
      final currentUser = User(
        id: '1',
        email: 'admin@example.com',
        name: 'Admin User',
        role: UserRole.committee,
      );

      expect(
        () => authService.register(
          '',
          'new@example.com',
          'password123',
          currentUser: currentUser,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('All fields are required'),
          ),
        ),
      );
    });

    test('register with invalid email throws exception', () async {
      final currentUser = User(
        id: '1',
        email: 'admin@example.com',
        name: 'Admin User',
        role: UserRole.committee,
      );

      expect(
        () => authService.register(
          'New User',
          'invalidemail',
          'password123',
          currentUser: currentUser,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Please enter a valid email'),
          ),
        ),
      );
    });

    test('register with short password throws exception', () async {
      final currentUser = User(
        id: '1',
        email: 'admin@example.com',
        name: 'Admin User',
        role: UserRole.committee,
      );

      expect(
        () => authService.register(
          'New User',
          'new@example.com',
          '12345', // menos de 6 caracteres
          currentUser: currentUser,
        ),
        throwsA(
          isA<Exception>().having(
            (e) => e.toString(),
            'message',
            contains('Password must be at least 6 characters'),
          ),
        ),
      );
    });
  });

  test('logout completes successfully', () async {
    // Verifica que el método logout no lance errores
    await expectLater(authService.logout(), completes);
  });
}
