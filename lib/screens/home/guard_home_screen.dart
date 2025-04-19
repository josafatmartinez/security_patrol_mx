// filepath: /home/josafatmartinez/Dev/security_patrol_mx/security_patrol_mx/lib/screens/home/guard_home_screen.dart
import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/checkpoint_model.dart';
import '../../models/patrol_model.dart';
import '../../widgets/home/welcome_card.dart';
import '../../widgets/home/action_card.dart';
import '../../widgets/home/activity_list.dart';
import '../../widgets/common/common_widgets.dart';
import '../../services/patrol_service.dart';
import '../profile/profile_screen.dart';
import '../checkpoint/scan_checkpoint_screen.dart';
import '../checkpoint/patrol_map_screen.dart';

class GuardHomeScreen extends StatefulWidget {
  final User user;

  const GuardHomeScreen({super.key, required this.user});

  @override
  State<GuardHomeScreen> createState() => _GuardHomeScreenState();
}

class _GuardHomeScreenState extends State<GuardHomeScreen> {
  int _selectedIndex = 0;
  final PatrolService _patrolService = PatrolService();
  Patrol? _activePatrol;

  @override
  void initState() {
    super.initState();
    _checkActivePatrol();
  }

  // Verificar si hay una patrulla activa para este guardia
  Future<void> _checkActivePatrol() async {
    setState(() {
    });

    try {
      final patrol = await _patrolService.getActivePatrolForGuard(
        widget.user.id ?? '',
      );
      setState(() {
        _activePatrol = patrol;
      });
    } catch (e) {
      setState(() {
      });
    }
  }

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
    } else if (index == 1) {
      // Índice para la pestaña de Mapa
      _navigateToMapScreen();
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  // Navegar a la pantalla de mapa
  void _navigateToMapScreen() {
    // Lista de checkpoints demo - en una app real se obtendrían de una API
    final checkpoints = [
      Checkpoint(
        id: '1',
        name: 'Entrada Principal',
        location: 'Zona A',
        description: 'Entrada principal del edificio',
        latitude: 19.432608,
        longitude: -99.133209,
      ),
      Checkpoint(
        id: '2',
        name: 'Sector B',
        location: 'Zona B',
        description: 'Sector B - Oficinas administrativas',
        latitude: 19.434608,
        longitude: -99.135209,
      ),
      Checkpoint(
        id: '3',
        name: 'Almacén',
        location: 'Zona C',
        description: 'Almacén de productos',
        latitude: 19.431608,
        longitude: -99.134209,
      ),
      Checkpoint(
        id: '4',
        name: 'Estacionamiento',
        location: 'Zona D',
        description: 'Estacionamiento de empleados',
        latitude: 19.433608,
        longitude: -99.132209,
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => PatrolMapScreen(
              user: widget.user,
              checkpoints: checkpoints,
              activePatrol: _activePatrol,
            ),
      ),
    ).then((_) {
      // Actualizar la patrulla activa cuando regrese de la pantalla de mapa
      _checkActivePatrol();
    });
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
                      _navigateToMapScreen();
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
