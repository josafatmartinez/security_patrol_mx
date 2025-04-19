import 'package:flutter/material.dart';
import 'package:security_patrol_mx/screens/checkpoint/checkpoint_create_screen.dart';
import '../../models/user_model.dart';
import '../../models/guard_model.dart';
import '../../models/checkpoint_model.dart';
import '../../widgets/home/welcome_card.dart';
import '../../widgets/home/activity_list.dart';
import '../../widgets/home/admin_actions_grid.dart';
import '../../widgets/common/common_widgets.dart';
import '../../utils/form_validator.dart';
import '../../utils/date_time_formatter.dart';
import '../profile/profile_screen.dart';

class CommitteeHomeScreen extends StatefulWidget {
  final User user;

  const CommitteeHomeScreen({super.key, required this.user});

  @override
  State<CommitteeHomeScreen> createState() => _CommitteeHomeScreenState();
}

class _CommitteeHomeScreenState extends State<CommitteeHomeScreen> {
  int _selectedIndex = 0;
  int _selectedAdminTab = 0;
  bool _showAdminPanel = false;

  // Datos para la sección de administración
  final List<Guard> _guards = [
    Guard(
      id: '1',
      name: 'Carlos Martínez',
      email: 'carlos@securitypatrol.mx',
      phone: '555-123-4567',
      isActive: true,
      lastCheckpoint: 'Entrada Principal',
      lastActivity: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    Guard(
      id: '2',
      name: 'María López',
      email: 'maria@securitypatrol.mx',
      phone: '555-987-6543',
      isActive: true,
      lastCheckpoint: 'Sector B',
      lastActivity: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    Guard(
      id: '3',
      name: 'Juan Gómez',
      email: 'juan@securitypatrol.mx',
      phone: '555-456-7890',
      isActive: false,
      lastCheckpoint: 'Almacén',
      lastActivity: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  final List<Checkpoint> _checkpoints = [
    Checkpoint(
      id: '1',
      name: 'Entrada Principal',
      location: 'Zona A',
      description: 'Entrada principal del edificio',
      lastChecked: DateTime.now().subtract(const Duration(hours: 2)),
      lastGuardId: '1',
    ),
    Checkpoint(
      id: '2',
      name: 'Sector B',
      location: 'Zona B',
      description: 'Sector B - Oficinas administrativas',
      lastChecked: DateTime.now().subtract(const Duration(minutes: 45)),
      lastGuardId: '2',
    ),
    Checkpoint(
      id: '3',
      name: 'Almacén',
      location: 'Zona C',
      description: 'Almacén de productos',
      lastChecked: DateTime.now().subtract(const Duration(days: 1)),
      lastGuardId: '3',
    ),
    Checkpoint(
      id: '4',
      name: 'Estacionamiento',
      location: 'Zona D',
      description: 'Estacionamiento de empleados',
      lastChecked: DateTime.now().subtract(const Duration(hours: 5)),
      lastGuardId: '1',
    ),
  ];

  // Controladores para agregar nuevos guardias
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  // Controladores para agregar nuevos checkpoints
  final _checkpointNameController = TextEditingController();
  final _checkpointLocationController = TextEditingController();
  final _checkpointDescriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _checkpointNameController.dispose();
    _checkpointLocationController.dispose();
    _checkpointDescriptionController.dispose();
    super.dispose();
  }

  void _onNavItemTapped(int index) {
    if (index == 3) {
      // Índice para la pestaña de Ajustes/Perfil
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
        _showAdminPanel = false;
      });
    }
  }

  void _toggleAdminPanel(bool show) {
    setState(() {
      _showAdminPanel = show;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Define los items de navegación para el comité
    final navigationItems = [
      const AppNavigationItem(icon: Icons.dashboard, label: 'Panel'),
      const AppNavigationItem(icon: Icons.people, label: 'Guardias'),
      const AppNavigationItem(icon: Icons.location_on, label: 'Mapas'),
      const AppNavigationItem(icon: Icons.settings, label: 'Ajustes'),
    ];

    // Lista de pestañas para el TabNavigator del panel admin

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _showAdminPanel ? 'Panel de Administración' : 'Panel de Comité',
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        leading:
            _showAdminPanel
                ? IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _toggleAdminPanel(false),
                )
                : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Notificaciones')));
            },
          ),
          if (_showAdminPanel)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  // Refrescar datos
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Datos actualizados')),
                  );
                });
              },
            ),
        ],
      ),
      body:
          _showAdminPanel
              ? _buildAdminPanel()
              : SingleChildScrollView(
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

                      // Main Actions Grid for Committee
                      const Text(
                        'Gestión Administrativa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Usando el widget extraído para mejorar la legibilidad
                      AdminActionsGrid(
                        onManageGuards: () {
                          _toggleAdminPanel(true);
                          setState(() {
                            _selectedAdminTab = 0; // Pestaña de Guardias
                          });
                        },
                        onConfigureCheckpoints: () {
                          _toggleAdminPanel(true);
                          setState(() {
                            _selectedAdminTab = 1; // Pestaña de Checkpoints
                          });
                        },
                        onViewReports: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Ver reportes')),
                          );
                        },
                        onViewActivities: () {
                          _toggleAdminPanel(true);
                          setState(() {
                            _selectedAdminTab = 2; // Pestaña de Actividades
                          });
                        },
                        onManageUsers: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Gestión de usuarios'),
                            ),
                          );
                        },
                        onScheduleRounds: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Programar rondas')),
                          );
                        },
                      ),

                      const SizedBox(height: 24),

                      // Recent Activity Section
                      const Text(
                        'Actividad del Sistema',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ActivityList(
                        activities: _getCommitteeActivities(),
                        onActivityTap: (activity) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Detalles: ${activity.title}'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      bottomNavigationBar:
          !_showAdminPanel
              ? AppBottomNavigationBar(
                currentIndex: _selectedIndex,
                items: navigationItems,
                onTap: _onNavItemTapped,
              )
              : null,
      floatingActionButton:
          _showAdminPanel && _selectedAdminTab != 2
              ? FloatingActionButton(
                onPressed: () {
                  _showAddDialog();
                },
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.add, color: Colors.white),
              )
              : null,
    );
  }

  // Método para construir el panel de administración
  Widget _buildAdminPanel() {
    // Lista de pestañas para el TabNavigator
    final tabs = [
      const TabItem(label: 'Guardias', icon: Icons.security),
      const TabItem(label: 'Checkpoints', icon: Icons.location_on),
      const TabItem(label: 'Actividades', icon: Icons.history),
    ];

    return Column(
      children: [
        // Pestañas de navegación usando el componente reutilizable
        TabNavigator(
          selectedIndex: _selectedAdminTab,
          tabs: tabs,
          onTabTap: (index) {
            setState(() {
              _selectedAdminTab = index;
            });
          },
        ),
        // Contenido
        Expanded(child: _buildAdminTabContent()),
      ],
    );
  }

  Widget _buildAdminTabContent() {
    switch (_selectedAdminTab) {
      case 0:
        return _buildGuardsTab();
      case 1:
        return _buildCheckpointsTab();
      case 2:
        return _buildActivitiesTab();
      default:
        return const Center(child: Text('Contenido no disponible'));
    }
  }

  Widget _buildGuardsTab() {
    return ListView.builder(
      itemCount: _guards.length,
      itemBuilder: (context, index) {
        final guard = _guards[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor:
                        guard.isActive ? Colors.green : Colors.grey,
                    child: const Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    guard.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: StatusIndicator(
                    isActive: guard.isActive,
                    activeText: 'Activo',
                    inactiveText: 'Inactivo',
                    size: 12.0,
                  ),
                ),
                const Divider(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.email, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            guard.email,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.phone, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            guard.phone,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (guard.lastCheckpoint != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Último checkpoint: ${guard.lastCheckpoint}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.indigo),
                      tooltip: 'Ver detalles',
                      onPressed: () {
                        _showGuardDetails(guard);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () {
                        _showEditGuardDialog(guard);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed: () {
                        _showDeleteDialog('guardia', guard.name, () {
                          setState(() {
                            _guards.removeAt(index);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckpointsTab() {
    return ListView.builder(
      itemCount: _checkpoints.length,
      itemBuilder: (context, index) {
        final checkpoint = _checkpoints[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: const Icon(Icons.location_on, color: Colors.white),
                  ),
                  title: Text(
                    checkpoint.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: StatusIndicator(
                    isActive: checkpoint.isActive,
                    activeText: 'Activo',
                    inactiveText: 'Inactivo',
                    size: 12.0,
                  ),
                ),
                const Divider(height: 8),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.map, size: 16, color: Colors.grey),
                          const SizedBox(width: 8),
                          Text(
                            'Ubicación: ${checkpoint.location}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      if (checkpoint.description != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.description,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Descripción: ${checkpoint.description}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                      if (checkpoint.lastChecked != null) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.access_time,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Última verificación: ${DateTimeFormatter.formatRelative(checkpoint.lastChecked!)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.visibility, color: Colors.indigo),
                      tooltip: 'Ver detalles',
                      onPressed: () {
                        _showCheckpointDetails(checkpoint);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      tooltip: 'Editar',
                      onPressed: () {
                        _showEditCheckpointDialog(checkpoint);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar',
                      onPressed: () {
                        _showDeleteDialog('checkpoint', checkpoint.name, () {
                          setState(() {
                            _checkpoints.removeAt(index);
                          });
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActivitiesTab() {
    final activities = _getAdminActivities();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Actividades Recientes',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ActivityList(
              activities: activities,
              onActivityTap: (activity) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Detalles: ${activity.title}')),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Helper method to get committee activities data
  List<ActivityItem> _getCommitteeActivities() {
    return [
      ActivityItem(
        title: 'Nuevo guardia registrado',
        description: 'Carlos Rodríguez - Turno Nocturno',
        time: '11:20 AM',
        icon: Icons.person_add,
        color: Colors.blue,
      ),
      ActivityItem(
        title: 'Checkpoint modificado',
        description: 'Estacionamiento Sur - Actualizado',
        time: '10:35 AM',
        icon: Icons.edit_location_alt,
        color: Colors.orange,
      ),
      ActivityItem(
        title: 'Reportes generados',
        description: 'Informe semanal - Área Norte',
        time: '09:15 AM',
        icon: Icons.summarize,
        color: Colors.green,
      ),
      ActivityItem(
        title: 'Alerta de sistema',
        description: 'Checkpoint #3 sin registros en 24h',
        time: 'Ayer, 18:45 PM',
        icon: Icons.warning,
        color: Colors.red,
      ),
    ];
  }

  // Helper method to get admin activities data
  List<ActivityItem> _getAdminActivities() {
    return [
      ActivityItem(
        title: 'Ronda completada',
        description: 'Guardia: Carlos Martínez - Sector A - Perímetro Norte',
        time: '10:35 AM',
        icon: Icons.check_circle,
        color: Colors.green,
      ),
      ActivityItem(
        title: 'Guardia registrado',
        description: 'Admin agregó a: María López',
        time: 'Hoy, 09:20 AM',
        icon: Icons.person_add,
        color: Colors.blue,
      ),
      ActivityItem(
        title: 'Incidente reportado',
        description: 'Guardia: Juan Gómez - Puerta trasera sin seguro',
        time: 'Ayer, 18:45 PM',
        icon: Icons.warning,
        color: Colors.orange,
      ),
      ActivityItem(
        title: 'Checkpoint agregado',
        description: 'Admin agregó: Estacionamiento - Zona D',
        time: 'Ayer, 15:00 PM',
        icon: Icons.add_location,
        color: Colors.purple,
      ),
      ActivityItem(
        title: 'Cambio de estado de guardia',
        description: 'Juan Gómez marcado como inactivo',
        time: 'Ayer, 14:30 PM',
        icon: Icons.person_off,
        color: Colors.red,
      ),
    ];
  }

  // Método para mostrar diálogos de guardias (agregar o editar)
  void _showGuardDialog({Guard? guard}) {
    // Si es un edit, inicializar controladores con valores actuales, si no, limpiar
    _nameController.text = guard?.name ?? '';
    _emailController.text = guard?.email ?? '';
    _phoneController.text = guard?.phone ?? '';
    bool isActive = guard?.isActive ?? true;

    final formFields = [
      CustomTextField(
        controller: _nameController,
        labelText: 'Nombre completo',
        prefixIcon: Icons.person,
        validator:
            (value) => FormValidator.validateRequired(value, 'el nombre'),
      ),
      const SizedBox(height: 16),
      CustomTextField(
        controller: _emailController,
        labelText: 'Correo electrónico',
        prefixIcon: Icons.email,
        keyboardType: TextInputType.emailAddress,
        validator: FormValidator.validateEmail,
      ),
      const SizedBox(height: 16),
      CustomTextField(
        controller: _phoneController,
        labelText: 'Teléfono',
        prefixIcon: Icons.phone,
        keyboardType: TextInputType.phone,
        validator: FormValidator.validatePhone,
      ),
    ];

    // Sólo mostrar el switch de estado si estamos editando
    if (guard != null) {
      formFields.add(const SizedBox(height: 16));
      formFields.add(
        StatefulBuilder(
          builder: (context, setState) {
            return StatusSwitchTile(
              title: 'Estado del guardia',
              value: isActive,
              onChanged: (bool value) {
                setState(() {
                  isActive = value;
                });
              },
            );
          },
        ),
      );
    }

    void saveGuard() {
      // Validar campos
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _phoneController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor complete todos los campos')),
        );
        return;
      }

      setState(() {
        if (guard == null) {
          // Agregar nuevo guardia
          _guards.add(
            Guard(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              isActive: true,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardia agregado correctamente')),
          );
        } else {
          // Actualizar guardia existente
          final index = _guards.indexWhere((g) => g.id == guard.id);
          if (index != -1) {
            _guards[index] = Guard(
              id: guard.id,
              name: _nameController.text,
              email: _emailController.text,
              phone: _phoneController.text,
              isActive: isActive,
              lastCheckpoint: guard.lastCheckpoint,
              lastActivity: guard.lastActivity,
              profileImage: guard.profileImage,
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Guardia actualizado correctamente')),
          );
        }
      });

      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormDialog(
          title: guard == null ? 'Agregar Guardia' : 'Editar Guardia',
          formFields: formFields,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveGuard,
        );
      },
    );
  }

  // Método para mostrar diálogos de checkpoints (agregar o editar)
  void _showCheckpointDialog({Checkpoint? checkpoint}) {
    // Si es un edit, inicializar controladores con valores actuales, si no, limpiar
    _checkpointNameController.text = checkpoint?.name ?? '';
    _checkpointLocationController.text = checkpoint?.location ?? '';
    _checkpointDescriptionController.text = checkpoint?.description ?? '';
    bool isActive = checkpoint?.isActive ?? true;

    final formFields = [
      CustomTextField(
        controller: _checkpointNameController,
        labelText: 'Nombre del checkpoint',
        prefixIcon: Icons.location_on,
        validator:
            (value) => FormValidator.validateRequired(value, 'el nombre'),
      ),
      const SizedBox(height: 16),
      CustomTextField(
        controller: _checkpointLocationController,
        labelText: 'Ubicación',
        prefixIcon: Icons.map,
        validator:
            (value) => FormValidator.validateRequired(value, 'la ubicación'),
      ),
      const SizedBox(height: 16),
      CustomTextField(
        controller: _checkpointDescriptionController,
        labelText: 'Descripción (opcional)',
        prefixIcon: Icons.description,
      ),
    ];

    // Sólo mostrar el switch de estado si estamos editando
    if (checkpoint != null) {
      formFields.add(const SizedBox(height: 16));
      formFields.add(
        StatefulBuilder(
          builder: (context, setState) {
            return StatusSwitchTile(
              title: 'Estado del checkpoint',
              value: isActive,
              onChanged: (bool value) {
                setState(() {
                  isActive = value;
                });
              },
            );
          },
        ),
      );
    }

    void saveCheckpoint() {
      // Validar campos
      if (_checkpointNameController.text.isEmpty ||
          _checkpointLocationController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor complete los campos requeridos'),
          ),
        );
        return;
      }

      setState(() {
        if (checkpoint == null) {
          // Agregar nuevo checkpoint
          _checkpoints.add(
            Checkpoint(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              name: _checkpointNameController.text,
              location: _checkpointLocationController.text,
              description:
                  _checkpointDescriptionController.text.isEmpty
                      ? null
                      : _checkpointDescriptionController.text,
              isActive: true,
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Checkpoint agregado correctamente')),
          );
        } else {
          // Actualizar checkpoint existente
          final index = _checkpoints.indexWhere((c) => c.id == checkpoint.id);
          if (index != -1) {
            _checkpoints[index] = Checkpoint(
              id: checkpoint.id,
              name: _checkpointNameController.text,
              location: _checkpointLocationController.text,
              description:
                  _checkpointDescriptionController.text.isEmpty
                      ? null
                      : _checkpointDescriptionController.text,
              isActive: isActive,
              lastChecked: checkpoint.lastChecked,
              lastGuardId: checkpoint.lastGuardId,
            );
          }
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Checkpoint actualizado correctamente'),
            ),
          );
        }
      });

      Navigator.of(context).pop();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return FormDialog(
          title:
              checkpoint == null ? 'Agregar Checkpoint' : 'Editar Checkpoint',
          formFields: formFields,
          onCancel: () => Navigator.of(context).pop(),
          onSave: saveCheckpoint,
        );
      },
    );
  }

  void _showEditGuardDialog(Guard guard) {
    _showGuardDialog(guard: guard);
  }

  void _showEditCheckpointDialog(Checkpoint checkpoint) {
    _showCheckpointDialog(checkpoint: checkpoint);
  }

  void _showAddDialog() {
    if (_selectedAdminTab == 0) {
      _showGuardDialog();
    } else if (_selectedAdminTab == 1) {
      // Navigate to the checkpoint creation screen instead of showing a dialog
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (context) => CheckpointCreateScreen(
                onCheckpointCreated: (newCheckpoint) {
                  setState(() {
                    _checkpoints.add(newCheckpoint);
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Checkpoint con QR agregado correctamente'),
                    ),
                  );
                },
              ),
        ),
      );
    }
  }

  void _showDeleteDialog(String type, String name, VoidCallback onDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: 'Eliminar $type',
          content: '¿Está seguro que desea eliminar "$name"?',
          cancelText: 'Cancelar',
          confirmText: 'Eliminar',
          confirmColor: Colors.red,
          confirmIcon: Icons.delete,
          onConfirm: () {
            onDelete();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('$type eliminado correctamente')),
            );
          },
        );
      },
    );
  }

  void _showGuardDetails(Guard guard) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final items = [
          DetailItem(icon: Icons.email, title: 'Correo', subtitle: guard.email),
          DetailItem(
            icon: Icons.phone,
            title: 'Teléfono',
            subtitle: guard.phone,
          ),
          DetailItem(
            icon: Icons.circle,
            title: 'Estado',
            subtitle: guard.isActive ? 'Activo' : 'Inactivo',
          ),
        ];

        if (guard.lastCheckpoint != null) {
          items.add(
            DetailItem(
              icon: Icons.location_on,
              title: 'Último checkpoint',
              subtitle: guard.lastCheckpoint!,
            ),
          );
        }

        if (guard.lastActivity != null) {
          items.add(
            DetailItem(
              icon: Icons.access_time,
              title: 'Última actividad',
              subtitle: _formatDateTime(guard.lastActivity!),
            ),
          );
        }

        return DetailCard(title: guard.name, items: items);
      },
    );
  }

  void _showCheckpointDetails(Checkpoint checkpoint) {
    // Encontrar el guardia que revisó este checkpoint por última vez
    final Guard? lastGuard =
        checkpoint.lastGuardId != null
            ? _guards.firstWhere(
              (g) => g.id == checkpoint.lastGuardId,
              orElse:
                  () => Guard(
                    id: '0',
                    name: 'Desconocido',
                    email: 'N/A',
                    phone: 'N/A',
                  ),
            )
            : null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final items = [
          DetailItem(
            icon: Icons.map,
            title: 'Ubicación',
            subtitle: checkpoint.location,
          ),
        ];

        if (checkpoint.description != null) {
          items.add(
            DetailItem(
              icon: Icons.description,
              title: 'Descripción',
              subtitle: checkpoint.description!,
            ),
          );
        }

        items.add(
          DetailItem(
            icon: Icons.circle,
            title: 'Estado',
            subtitle: checkpoint.isActive ? 'Activo' : 'Inactivo',
          ),
        );

        if (checkpoint.lastChecked != null) {
          items.add(
            DetailItem(
              icon: Icons.access_time,
              title: 'Última verificación',
              subtitle: _formatDateTime(checkpoint.lastChecked!),
            ),
          );
        }

        if (lastGuard != null) {
          items.add(
            DetailItem(
              icon: Icons.person,
              title: 'Último guardia',
              subtitle: lastGuard.name,
            ),
          );
        }

        return DetailCard(title: checkpoint.name, items: items);
      },
    );
  }

  String _formatDateTime(DateTime dateTime) {
    // Usar nuestra utilidad de formateo de fechas
    return DateTimeFormatter.formatRelative(dateTime);
  }
}
