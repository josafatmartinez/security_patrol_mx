import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import '../../models/user_model.dart';
import '../../models/checkpoint_model.dart';
import '../../models/patrol_model.dart';
import '../../services/patrol_service.dart';
import 'dart:async';

class PatrolMapScreen extends StatefulWidget {
  final User user;
  final List<Checkpoint> checkpoints;
  final Patrol? activePatrol;

  const PatrolMapScreen({
    super.key,
    required this.user,
    required this.checkpoints,
    this.activePatrol,
  });

  @override
  State<PatrolMapScreen> createState() => _PatrolMapScreenState();
}

class _PatrolMapScreenState extends State<PatrolMapScreen> {
  final PatrolService _patrolService = PatrolService();
  final MapController _mapController = MapController();
  Position? _currentPosition;
  Patrol? _activePatrol;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isFollowingUser = true;
  // Timer para las actualizaciones de ubicación
  Timer? _locationTimer;

  // Lista de marcadores para los checkpoints
  final List<Marker> _checkpointMarkers = [];
  // Lista de puntos para la ruta
  final List<LatLng> _routePoints = [];

  @override
  void initState() {
    super.initState();
    _activePatrol = widget.activePatrol;
    _loadCheckpoints();
    _getCurrentLocation();
    // Actualizar la ubicación cada 10 segundos
    _startLocationUpdates();
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    super.dispose();
  }

  // Iniciar las actualizaciones periódicas de ubicación
  void _startLocationUpdates() {
    _locationTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        _getCurrentLocation();
      }
    });
  }

  // Cargar los checkpoints en el mapa
  void _loadCheckpoints() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      _checkpointMarkers.clear();

      // Crear marcadores para cada checkpoint
      for (var checkpoint in widget.checkpoints) {
        if (checkpoint.latitude != null && checkpoint.longitude != null) {
          final marker = Marker(
            width: 40.0,
            height: 40.0,
            point: LatLng(checkpoint.latitude!, checkpoint.longitude!),
            child: _buildCheckpointMarker(checkpoint),
          );
          _checkpointMarkers.add(marker);
        }
      }

      // Si hay una patrulla activa, cargar las visitas
      if (_activePatrol != null) {
        _loadPatrolRoute();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al cargar los checkpoints: $e';
      });
    }
  }

  // Cargar la ruta de la patrulla en el mapa
  void _loadPatrolRoute() {
    if (_activePatrol == null) return;

    _routePoints.clear();

    // Ordenar las visitas por timestamp
    final visits = List<PatrolVisit>.from(_activePatrol!.visits)
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    // Agregar puntos para cada visita
    for (var visit in visits) {
      if (visit.latitude != null && visit.longitude != null) {
        _routePoints.add(LatLng(visit.latitude!, visit.longitude!));
      }
    }
  }

  // Obtener la ubicación actual
  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      setState(() {
        _currentPosition = position;

        // Si estamos siguiendo al usuario, centrar el mapa en su posición
        if (_isFollowingUser) {
          _mapController.move(
            LatLng(position.latitude, position.longitude),
            _mapController.camera.zoom,
          );
        }

        // Actualizar la ruta si hay una patrulla activa
        if (_activePatrol != null) {
          _loadPatrolRoute();
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error al obtener la ubicación: $e';
      });
    }
  }

  // Construir el marcador para un checkpoint
  Widget _buildCheckpointMarker(Checkpoint checkpoint) {
    final bool isVisited =
        _activePatrol?.visits.any(
          (visit) => visit.checkpointId == checkpoint.id,
        ) ??
        false;

    return GestureDetector(
      onTap: () {
        _showCheckpointDialog(checkpoint);
      },
      child: Container(
        decoration: BoxDecoration(
          color: isVisited ? Colors.green : Colors.blue,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Icon(Icons.location_on, color: Colors.white, size: 24),
      ),
    );
  }

  // Mostrar diálogo para registrar visita a un checkpoint
  void _showCheckpointDialog(Checkpoint checkpoint) {
    final bool isVisited =
        _activePatrol?.visits.any(
          (visit) => visit.checkpointId == checkpoint.id,
        ) ??
        false;

    final TextEditingController notesController = TextEditingController();
    bool hasIncident = false;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(checkpoint.name),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ubicación: ${checkpoint.location}'),
                    if (checkpoint.description != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text('Descripción: ${checkpoint.description}'),
                      ),
                    const SizedBox(height: 16),
                    if (isVisited)
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.green.withAlpha(51),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Ya has registrado este checkpoint en esta ronda',
                          style: TextStyle(color: Colors.green),
                        ),
                      )
                    else if (_activePatrol != null) ...[
                      const Text(
                        'Detalles de la visita:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: notesController,
                        decoration: const InputDecoration(
                          labelText: 'Notas (opcional)',
                          border: OutlineInputBorder(),
                          hintText: 'Añadir observaciones...',
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        title: const Text('¿Hay incidencias?'),
                        subtitle: const Text(
                          'Activa si hay alguna anomalía o situación que reportar',
                        ),
                        value: hasIncident,
                        activeColor: Colors.red,
                        onChanged: (value) {
                          setState(() {
                            hasIncident = value;
                          });
                        },
                      ),
                    ] else
                      const Text(
                        'Inicia una patrulla para registrar visitas',
                        style: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('CANCELAR'),
                ),
                if (!isVisited && _activePatrol != null)
                  FilledButton(
                    onPressed: () {
                      _registerCheckpointVisit(
                        checkpoint,
                        notesController.text.trim().isEmpty
                            ? null
                            : notesController.text.trim(),
                        hasIncident,
                      );
                      Navigator.of(context).pop();
                    },
                    child: const Text('REGISTRAR VISITA'),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  // Registrar visita a un checkpoint
  Future<void> _registerCheckpointVisit(
    Checkpoint checkpoint,
    String? notes,
    bool hasIncident,
  ) async {
    if (_activePatrol == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final visit = await _patrolService.registerCheckpointVisit(
        patrolId: _activePatrol!.id,
        checkpointId: checkpoint.id,
        guardId: widget.user.id ?? '',
        notes: notes,
        hasIncident: hasIncident,
      );

      if (visit != null) {
        // Actualizar el estado local de la patrulla
        setState(() {
          _activePatrol = Patrol(
            id: _activePatrol!.id,
            guardId: _activePatrol!.guardId,
            startTime: _activePatrol!.startTime,
            endTime: _activePatrol!.endTime,
            visits: List<PatrolVisit>.from(_activePatrol!.visits)..add(visit),
            isCompleted: _activePatrol!.isCompleted,
          );
          _loadPatrolRoute();
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Visita registrada a ${checkpoint.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al registrar la visita: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Si no hay posición actual, mostrar posición predeterminada (Ciudad de México)
    final LatLng center =
        _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : LatLng(
              19.432608,
              -99.133209,
            ); // Ciudad de México como valor predeterminado

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de Rondín'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(
              _isFollowingUser ? Icons.gps_fixed : Icons.gps_not_fixed,
            ),
            onPressed: () {
              setState(() {
                _isFollowingUser = !_isFollowingUser;
                if (_isFollowingUser && _currentPosition != null) {
                  _mapController.move(
                    LatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    _mapController.camera.zoom,
                  );
                }
              });
            },
            tooltip:
                _isFollowingUser ? 'Dejar de seguir' : 'Seguir mi ubicación',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getCurrentLocation,
            tooltip: 'Actualizar ubicación',
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Expanded(
                    child: FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: center,
                        initialZoom: 15.0,
                        onMapReady: () {
                          // Mover el mapa a la ubicación actual cuando esté listo
                          if (_currentPosition != null) {
                            _mapController.move(
                              LatLng(
                                _currentPosition!.latitude,
                                _currentPosition!.longitude,
                              ),
                              15.0,
                            );
                          }
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          userAgentPackageName: 'com.securitypatrol.app',
                        ),
                        // Línea de la ruta recorrida
                        if (_routePoints.isNotEmpty)
                          PolylineLayer(
                            polylines: [
                              Polyline(
                                points: _routePoints,
                                color: Colors.red,
                                strokeWidth: 4.0,
                              ),
                            ],
                          ),
                        // Marcadores de los checkpoints
                        MarkerLayer(markers: _checkpointMarkers),
                        // Marcador de la posición actual
                        if (_currentPosition != null)
                          MarkerLayer(
                            markers: [
                              Marker(
                                width: 40.0,
                                height: 40.0,
                                point: LatLng(
                                  _currentPosition!.latitude,
                                  _currentPosition!.longitude,
                                ),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withAlpha(128),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.person_pin_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (_errorMessage != null)
                    Container(
                      color: Colors.red,
                      padding: const EdgeInsets.all(8.0),
                      width: double.infinity,
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  // Información de la patrulla actual
                  if (_activePatrol != null)
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Patrulla en curso: ${_formatDateTime(_activePatrol!.startTime)}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Checkpoints visitados: ${_activePatrol!.visits.length} de ${widget.checkpoints.length}',
                          ),
                        ],
                      ),
                    ),
                ],
              ),
      floatingActionButton:
          _activePatrol == null
              ? FloatingActionButton(
                onPressed: _startNewPatrol,
                backgroundColor: Theme.of(context).colorScheme.primary,
                child: const Icon(Icons.play_arrow, color: Colors.white),
              )
              : FloatingActionButton(
                onPressed: _completePatrol,
                backgroundColor: Colors.green,
                child: const Icon(Icons.check, color: Colors.white),
              ),
    );
  }

  // Iniciar una nueva patrulla
  Future<void> _startNewPatrol() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final patrol = await _patrolService.startPatrol(widget.user.id ?? '');

      setState(() {
        _activePatrol = patrol;
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Patrulla iniciada correctamente!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al iniciar la patrulla: $e';
      });
    }
  }

  // Completar la patrulla actual
  Future<void> _completePatrol() async {
    if (_activePatrol == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final completedPatrol = await _patrolService.completePatrol(
        _activePatrol!.id,
      );

      setState(() {
        _activePatrol = null;
        _routePoints.clear();
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Patrulla completada. Duración: ${_formatDuration(completedPatrol!.startTime, completedPatrol.endTime ?? DateTime.now())}',
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Error al completar la patrulla: $e';
      });
    }
  }

  // Formatear un objeto DateTime
  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Calcular la duración entre dos fechas
  String _formatDuration(DateTime start, DateTime end) {
    final difference = end.difference(start);
    final hours = difference.inHours;
    final minutes = difference.inMinutes % 60;

    return '$hours h $minutes min';
  }
}
