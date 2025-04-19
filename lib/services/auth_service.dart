import 'dart:async' show Future;
import '../models/user_model.dart';

class AuthService {
  // This is a simplified implementation for demonstration
  // In a real app, this would connect to an API or Firebase

  Future<User?> login(String email, String password) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // For demo purposes only - in real app use secure authentication
    if (email == 'admin@example.com' && password == 'admin123') {
      // Usuario con rol de comité/administrador
      return User(
        id: '1',
        email: email,
        name: 'Admin User',
        role: UserRole.committee,
      );
    } else if (email == 'guard@example.com' && password == 'guard123') {
      // Usuario con rol de guardia
      return User(
        id: '2',
        email: email,
        name: 'Guard User',
        role: UserRole.guard,
      );
    } else if (email == 'test@example.com' && password == 'password123') {
      // Usuario normal (guardia por defecto)
      return User(id: '3', email: email, name: 'Test User');
    } else {
      throw Exception('Invalid credentials');
    }
  }

  // Método modificado para que solo sea utilizable por usuarios con permisos adecuados
  Future<User?> register(
    String name,
    String email,
    String password, {
    UserRole role = UserRole.guard,
    required User currentUser,
  }) async {
    // Verificar si el usuario actual tiene permisos para registrar nuevos usuarios
    if (currentUser.role != UserRole.committee &&
        currentUser.role != UserRole.superAdmin) {
      throw Exception('No tienes permisos para registrar nuevos usuarios');
    }

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Simple validation
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw Exception('All fields are required');
    }

    if (!email.contains('@')) {
      throw Exception('Please enter a valid email');
    }

    if (password.length < 6) {
      throw Exception('Password must be at least 6 characters');
    }

    // For demo purposes only - in real app use secure user creation
    // Simulate successful registration
    return User(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      email: email,
      name: name,
      role: role, // Usar el rol proporcionado
    );
  }

  Future<void> logout() async {
    // Clear tokens, session etc.
    await Future.delayed(const Duration(milliseconds: 500));
    // In a real app, you would clear tokens from secure storage
  }
}
