class Guard {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? profileImage;
  final bool isActive;
  final String? lastCheckpoint;
  final DateTime? lastActivity;

  Guard({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profileImage,
    this.isActive = true,
    this.lastCheckpoint,
    this.lastActivity,
  });

  factory Guard.fromJson(Map<String, dynamic> json) {
    return Guard(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      profileImage: json['profileImage'],
      isActive: json['isActive'] ?? true,
      lastCheckpoint: json['lastCheckpoint'],
      lastActivity:
          json['lastActivity'] != null
              ? DateTime.parse(json['lastActivity'])
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profileImage': profileImage,
      'isActive': isActive,
      'lastCheckpoint': lastCheckpoint,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }
}
