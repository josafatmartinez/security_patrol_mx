import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';
import '../../widgets/common/theme_switcher.dart';

class ProfileScreen extends StatefulWidget {
  final User user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _authService = AuthService();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.user.name ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _getRoleName() {
    switch (widget.user.role) {
      case UserRole.guard:
        return 'Guardia';
      case UserRole.committee:
        return 'Administrador (Comité)';
      case UserRole.superAdmin:
        return 'Super Administrador';
    }
  }

  Future<void> _logout() async {
    try {
      await _authService.logout();
      if (!mounted) return;

      // Redirigir al login
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  // Aquí se implementaría la funcionalidad para guardar los cambios
                  // Por ahora solo mostramos un mensaje
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cambios guardados')),
                  );
                  setState(() {
                    _isEditing = false;
                  });
                }
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar y nombre
              Center(
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: Text(
                        (widget.user.name?.isNotEmpty == true)
                            ? widget.user.name![0].toUpperCase()
                            : widget.user.email[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isEditing
                        ? TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingresa tu nombre';
                            }
                            return null;
                          },
                        )
                        : Text(
                          widget.user.name ?? 'Sin nombre',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Información de usuario
              const Text(
                'Información de cuenta',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Correo electrónico
              ListTile(
                leading: const Icon(Icons.email),
                title: const Text('Correo electrónico'),
                subtitle: Text(widget.user.email),
              ),

              const Divider(),

              // Rol
              ListTile(
                leading: const Icon(Icons.security),
                title: const Text('Rol'),
                subtitle: Text(_getRoleName()),
              ),

              const Divider(),

              // ID de usuario
              ListTile(
                leading: const Icon(Icons.perm_identity),
                title: const Text('ID de usuario'),
                subtitle: Text(widget.user.id ?? 'No disponible'),
              ),

              const SizedBox(height: 32),

              // Sección Apariencia
              const Text(
                'Apariencia',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Selector de tema (claro/oscuro)
              const ThemeSwitcher(),

              const Divider(),

              // Sección Acciones
              const Text(
                'Acciones',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Cambiar contraseña
              ListTile(
                leading: const Icon(Icons.lock),
                title: const Text('Cambiar contraseña'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Función de cambio de contraseña pendiente',
                      ),
                    ),
                  );
                },
              ),

              const Divider(),

              // Cerrar sesión
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red[700]),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.red[700]),
                ),
                onTap: _logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
