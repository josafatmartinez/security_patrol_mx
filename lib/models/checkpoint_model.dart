class Checkpoint {
  final String id;
  final String name;
  final String location;
  final String? description;
  final bool isActive;
  final DateTime? lastChecked;
  final String? lastGuardId;
  final double? latitude;
  final double? longitude;
  final String? qrCode;

  Checkpoint({
    required this.id,
    required this.name,
    required this.location,
    this.description,
    this.isActive = true,
    this.lastChecked,
    this.lastGuardId,
    this.latitude,
    this.longitude,
    this.qrCode,
  });

  factory Checkpoint.fromJson(Map<String, dynamic> json) {
    return Checkpoint(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      description: json['description'],
      isActive: json['isActive'] ?? true,
      lastChecked:
          json['lastChecked'] != null
              ? DateTime.parse(json['lastChecked'])
              : null,
      lastGuardId: json['lastGuardId'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      qrCode: json['qrCode'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'description': description,
      'isActive': isActive,
      'lastChecked': lastChecked?.toIso8601String(),
      'lastGuardId': lastGuardId,
      'latitude': latitude,
      'longitude': longitude,
      'qrCode': qrCode,
    };
  }
}
