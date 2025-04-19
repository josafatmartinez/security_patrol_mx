import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/patrol_model.dart';
import '../models/checkpoint_model.dart';
import 'package:geolocator/geolocator.dart';

class PatrolService {
  // En una aplicación real estos datos vendrían de una base de datos o API
  final List<Patrol> _activePatrols = [];
  final List<Patrol> _completedPatrols = [];

  // Método para iniciar una nueva patrulla
  Future<Patrol> startPatrol(String guardId) async {
    final id = 'patrol_${DateTime.now().millisecondsSinceEpoch}';
    final newPatrol = Patrol(
      id: id,
      guardId: guardId,
      startTime: DateTime.now(),
      visits: [],
      isCompleted: false,
    );

    _activePatrols.add(newPatrol);
    debugPrint('Nueva patrulla iniciada: $id por guardia $guardId');
    return newPatrol;
  }

  // Método para finalizar una patrulla
  Future<Patrol?> completePatrol(String patrolId) async {
    final patrolIndex = _activePatrols.indexWhere((p) => p.id == patrolId);
    if (patrolIndex >= 0) {
      final patrol = _activePatrols[patrolIndex];
      final completedPatrol = Patrol(
        id: patrol.id,
        guardId: patrol.guardId,
        startTime: patrol.startTime,
        endTime: DateTime.now(),
        visits: patrol.visits,
        isCompleted: true,
      );

      _activePatrols.removeAt(patrolIndex);
      _completedPatrols.add(completedPatrol);

      debugPrint('Patrulla completada: $patrolId');
      return completedPatrol;
    }
    return null;
  }

  // Método para registrar una visita a un checkpoint
  Future<PatrolVisit?> registerCheckpointVisit({
    required String patrolId,
    required String checkpointId,
    required String guardId,
    String? notes,
    bool hasIncident = false,
  }) async {
    try {
      // Obtener ubicación actual
      Position position = await _getCurrentPosition();

      final patrolIndex = _activePatrols.indexWhere((p) => p.id == patrolId);
      if (patrolIndex >= 0) {
        final patrol = _activePatrols[patrolIndex];

        final visit = PatrolVisit(
          id: 'visit_${DateTime.now().millisecondsSinceEpoch}',
          checkpointId: checkpointId,
          guardId: guardId,
          timestamp: DateTime.now(),
          latitude: position.latitude,
          longitude: position.longitude,
          notes: notes,
          hasIncident: hasIncident,
        );

        final updatedVisits = List<PatrolVisit>.from(patrol.visits)..add(visit);

        _activePatrols[patrolIndex] = Patrol(
          id: patrol.id,
          guardId: patrol.guardId,
          startTime: patrol.startTime,
          visits: updatedVisits,
          isCompleted: patrol.isCompleted,
        );

        debugPrint('Visita registrada: $checkpointId por guardia $guardId');
        return visit;
      }
      return null;
    } catch (e) {
      debugPrint('Error al registrar visita: $e');
      return null;
    }
  }

  // Obtener la patrulla activa para un guardia específico
  Future<Patrol?> getActivePatrolForGuard(String guardId) async {
    return _activePatrols.firstWhere(
      (patrol) => patrol.guardId == guardId && !patrol.isCompleted,
      orElse: () => null!,
    );
  }

  // Obtener las patrullas completadas para un guardia específico
  Future<List<Patrol>> getCompletedPatrolsForGuard(String guardId) async {
    return _completedPatrols
        .where((patrol) => patrol.guardId == guardId && patrol.isCompleted)
        .toList();
  }

  // Obtener todas las patrullas completadas
  Future<List<Patrol>> getAllCompletedPatrols() async {
    return List<Patrol>.from(_completedPatrols);
  }

  // Método auxiliar para obtener la posición actual
  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Los permisos de ubicación fueron denegados');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Los permisos de ubicación están permanentemente denegados, no podemos solicitar permisos.',
      );
    }

    // Obtener la posición actual
    return await Geolocator.getCurrentPosition();
  }
}
