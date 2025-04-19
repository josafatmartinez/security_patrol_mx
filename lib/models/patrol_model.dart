class PatrolVisit {
  final String id;
  final String checkpointId;
  final String guardId;
  final DateTime timestamp;
  final double? latitude;
  final double? longitude;
  final String? notes;
  final bool hasIncident;

  PatrolVisit({
    required this.id,
    required this.checkpointId,
    required this.guardId,
    required this.timestamp,
    this.latitude,
    this.longitude,
    this.notes,
    this.hasIncident = false,
  });

  factory PatrolVisit.fromJson(Map<String, dynamic> json) {
    return PatrolVisit(
      id: json['id'],
      checkpointId: json['checkpointId'],
      guardId: json['guardId'],
      timestamp: DateTime.parse(json['timestamp']),
      latitude: json['latitude'],
      longitude: json['longitude'],
      notes: json['notes'],
      hasIncident: json['hasIncident'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'checkpointId': checkpointId,
      'guardId': guardId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
      'hasIncident': hasIncident,
    };
  }
}

class Patrol {
  final String id;
  final String guardId;
  final DateTime startTime;
  final DateTime? endTime;
  final List<PatrolVisit> visits;
  final bool isCompleted;

  Patrol({
    required this.id,
    required this.guardId,
    required this.startTime,
    this.endTime,
    required this.visits,
    this.isCompleted = false,
  });

  factory Patrol.fromJson(Map<String, dynamic> json) {
    return Patrol(
      id: json['id'],
      guardId: json['guardId'],
      startTime: DateTime.parse(json['startTime']),
      endTime: json['endTime'] != null ? DateTime.parse(json['endTime']) : null,
      visits:
          (json['visits'] as List)
              .map((visit) => PatrolVisit.fromJson(visit))
              .toList(),
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'guardId': guardId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'visits': visits.map((visit) => visit.toJson()).toList(),
      'isCompleted': isCompleted,
    };
  }
}
