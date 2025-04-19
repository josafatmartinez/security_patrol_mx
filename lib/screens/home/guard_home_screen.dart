// filepath: /home/josafatmartinez/Dev/security_patrol_mx/security_patrol_mx/lib/screens/home/guard_home_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../widgets/home/welcome_card.dart';
import '../../widgets/home/action_card.dart';
import '../../widgets/home/activity_list.dart';
import '../../widgets/common/common_widgets.dart';
import '../profile/profile_screen.dart';
import '../checkpoint/scan_checkpoint_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  final User user;

  const GuardHomeScreen({super.key, required this.user});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  int _selectedIndex = 0;

  void _onNavItemTapped(int index) {
    if (index == 3) {
      // Índice para la pestaña de Perfil
      // Abrir la pantalla de perfil
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileScreen(user: widget.user),
        ),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define los items de navegación para el guardia
    final navigationItems = [
      const AppNavigationItem(icon: Icons.home, label: 'Inicio'),
      const AppNavigationItem(icon: Icons.map, label: 'Mapa'),
      const AppNavigationItem(icon: Icons.history, label: 'Historial'),
      const AppNavigationItem(icon: Icons.person, label: 'Perfil'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Guardia'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Notificaciones')));
            },
          ),
          // Se eliminó el ícono de perfil redundante
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Card
              WelcomeCard(
                user: widget.user,
                onStatusButtonPressed: (text) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(text)));
                },
              ),

              const SizedBox(height: 24),

              // Main Actions Grid for Guards
              const Text(
                'Acciones rápidas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  ActionCard(
                    title: 'Escanear QR',
                    icon: Icons.qr_code_scanner,
                    color: Colors.blue,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  ScanCheckpointScreen(user: widget.user),
                        ),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'Reportar Incidente',
                    icon: Icons.warning_amber,
                    color: Colors.orange,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Reportar incidente')),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'Ver Ruta',
                    icon: Icons.route,
                    color: Colors.green,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Ver ruta de patrullaje')),
                      );
                    },
                  ),
                  ActionCard(
                    title: 'Registrar Actividad',
                    icon: Icons.note_add,
                    color: Colors.purple,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Registrar actividad')),
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Recent Activity Section
              const Text(
                'Mis Actividades Recientes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ActivityList(
                activities: _getGuardActivities(),
                onActivityTap: (activity) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Detalles: ${activity.title}')),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _selectedIndex,
        items: navigationItems,
        onTap: _onNavItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Implementar alerta SOS usando ConfirmationDialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ConfirmationDialog(
                title: 'Alerta SOS',
                content: '¿Estás seguro de enviar una alerta SOS?',
                cancelText: 'Cancelar',
                confirmText: 'Enviar',
                confirmColor: Colors.red,
                onConfirm: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Alerta SOS enviada'),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
              );
            },
          );
        },
        backgroundColor: Colors.red,
        child: const Icon(Icons.emergency, color: Colors.white),
      ),
    );
  }

  // Helper method to get guard activities data
  List<ActivityItem> _getGuardActivities() {
    return [
      ActivityItem(
        title: 'Checkpoint escaneado',
        description: 'Entrada Principal - QR verificado',
        time: '10:35 AM',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      ActivityItem(
        title: 'Ronda completada',
        description: 'Sector A - Perímetro Norte',
        time: '09:20 AM',
        icon: Icons.route,
        color: Colors.blue,
      ),
      ActivityItem(
        title: 'Incidente reportado',
        description: 'Puerta trasera sin seguro',
        time: 'Ayer, 18:45 PM',
        icon: Icons.warning,
        color: Colors.orange,
      ),
      ActivityItem(
        title: 'Inicio de turno',
        description: 'Turno matutino - 8:00 AM',
        time: 'Ayer, 08:00 AM',
        icon: Icons.login,
        color: Colors.purple,
      ),
    ];
  }
}
