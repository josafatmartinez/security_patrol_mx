enum UserRole {
  guard, // Guardias
  committee, // Comité (administradores)
  superAdmin, // Super administrador (usuario que crea miembros del comité)
}

class User {
  final String? id;
  final String email;
  final String? name;
  final UserRole role;

  User({
    this.id,
    required this.email,
    this.name,
    this.role = UserRole.guard, // Por defecto, los usuarios son guardias
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      role: _roleFromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role.toString().split('.').last,
    };
  }

  // Método para convertir string a UserRole
  static UserRole _roleFromString(String? roleStr) {
    if (roleStr == 'committee') {
      return UserRole.committee;
    } else if (roleStr == 'superAdmin') {
      return UserRole.superAdmin;
    }
    return UserRole.guard; // valor por defecto
  }

  // Métodos de utilidad para verificar los roles
  bool isCommittee() => role == UserRole.committee;
  bool isGuard() => role == UserRole.guard;
  bool isSuperAdmin() => role == UserRole.superAdmin;
  bool canManageUsers() =>
      role == UserRole.committee || role == UserRole.superAdmin;
}
