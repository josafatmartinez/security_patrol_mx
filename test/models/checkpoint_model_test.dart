import 'package:flutter_test/flutter_test.dart';
import 'package:security_patrol_mx/models/checkpoint_model.dart';

void main() {
  group('Checkpoint Model Tests', () {
    test('Checkpoint constructor creates instance correctly', () {
      final DateTime now = DateTime.now();
      final checkpoint = Checkpoint(
        id: '1',
        name: 'Entrada Principal',
        location: 'Coordenadas: 19.4326, -99.1332',
        description: 'Punto de acceso principal al edificio',
        isActive: true,
        lastChecked: now,
        lastGuardId: 'guard-123',
      );

      expect(checkpoint.id, '1');
      expect(checkpoint.name, 'Entrada Principal');
      expect(checkpoint.location, 'Coordenadas: 19.4326, -99.1332');
      expect(checkpoint.description, 'Punto de acceso principal al edificio');
      expect(checkpoint.isActive, true);
      expect(checkpoint.lastChecked, now);
      expect(checkpoint.lastGuardId, 'guard-123');
    });

    test('Checkpoint constructor uses default values', () {
      final checkpoint = Checkpoint(
        id: '1',
        name: 'Entrada Principal',
        location: 'Coordenadas: 19.4326, -99.1332',
      );

      expect(checkpoint.id, '1');
      expect(checkpoint.name, 'Entrada Principal');
      expect(checkpoint.location, 'Coordenadas: 19.4326, -99.1332');
      expect(checkpoint.description, null);
      expect(checkpoint.isActive, true); // default value
      expect(checkpoint.lastChecked, null);
      expect(checkpoint.lastGuardId, null);
    });

    test('Checkpoint.fromJson creates instance correctly', () {
      final now = DateTime.now();
      final json = {
        'id': '1',
        'name': 'Entrada Principal',
        'location': 'Coordenadas: 19.4326, -99.1332',
        'description': 'Punto de acceso principal al edificio',
        'isActive': true,
        'lastChecked': now.toIso8601String(),
        'lastGuardId': 'guard-123',
      };

      final checkpoint = Checkpoint.fromJson(json);

      expect(checkpoint.id, '1');
      expect(checkpoint.name, 'Entrada Principal');
      expect(checkpoint.location, 'Coordenadas: 19.4326, -99.1332');
      expect(checkpoint.description, 'Punto de acceso principal al edificio');
      expect(checkpoint.isActive, true);
      expect(checkpoint.lastChecked?.toIso8601String(), now.toIso8601String());
      expect(checkpoint.lastGuardId, 'guard-123');
    });

    test('Checkpoint.fromJson handles missing optional values', () {
      final json = {
        'id': '1',
        'name': 'Entrada Principal',
        'location': 'Coordenadas: 19.4326, -99.1332',
      };

      final checkpoint = Checkpoint.fromJson(json);

      expect(checkpoint.id, '1');
      expect(checkpoint.name, 'Entrada Principal');
      expect(checkpoint.location, 'Coordenadas: 19.4326, -99.1332');
      expect(checkpoint.description, null);
      expect(checkpoint.isActive, true); // Should use default
      expect(checkpoint.lastChecked, null);
      expect(checkpoint.lastGuardId, null);
    });

    test('Checkpoint.toJson converts instance to json correctly', () {
      final now = DateTime.now();
      final checkpoint = Checkpoint(
        id: '1',
        name: 'Entrada Principal',
        location: 'Coordenadas: 19.4326, -99.1332',
        description: 'Punto de acceso principal al edificio',
        isActive: true,
        lastChecked: now,
        lastGuardId: 'guard-123',
      );

      final json = checkpoint.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Entrada Principal');
      expect(json['location'], 'Coordenadas: 19.4326, -99.1332');
      expect(json['description'], 'Punto de acceso principal al edificio');
      expect(json['isActive'], true);
      expect(json['lastChecked'], now.toIso8601String());
      expect(json['lastGuardId'], 'guard-123');
    });

    test('Checkpoint.toJson handles null values', () {
      final checkpoint = Checkpoint(
        id: '1',
        name: 'Entrada Principal',
        location: 'Coordenadas: 19.4326, -99.1332',
      );

      final json = checkpoint.toJson();

      expect(json['id'], '1');
      expect(json['name'], 'Entrada Principal');
      expect(json['location'], 'Coordenadas: 19.4326, -99.1332');
      expect(json['description'], null);
      expect(json['isActive'], true);
      expect(json['lastChecked'], null);
      expect(json['lastGuardId'], null);
    });
  });
}
