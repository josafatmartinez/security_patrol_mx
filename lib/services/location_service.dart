import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // Singleton pattern
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  // Verificar y solicitar permisos de ubicación
  Future<bool> requestLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar si el servicio de ubicación está habilitado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Mostrar diálogo para que el usuario active la ubicación
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Ubicación desactivada'),
              content: const Text(
                'Para usar esta función, necesitas activar los servicios de ubicación de tu dispositivo.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Abrir Configuración'),
                  onPressed: () {
                    Geolocator.openLocationSettings();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return false;
    }

    // Verificar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      // Solicitar permisos
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Mostrar mensaje de que se denegaron los permisos
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Los permisos de ubicación son necesarios para esta funcionalidad',
              ),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Mostrar mensaje de que los permisos están permanentemente denegados
      if (context.mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Permisos de ubicación'),
              content: const Text(
                'Los permisos de ubicación están permanentemente denegados. Por favor, habilítalos desde la configuración de tu dispositivo.',
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Abrir Configuración'),
                  onPressed: () {
                    Geolocator.openAppSettings();
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Cancelar'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
      return false;
    }

    // Si llegamos aquí, los permisos están concedidos
    return true;
  }

  // Obtener la ubicación actual
  Future<Position?> getCurrentLocation(BuildContext context) async {
    bool permissionGranted = await requestLocationPermission(context);

    if (permissionGranted) {
      try {
        return await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
      } catch (e) {
        debugPrint('Error obteniendo ubicación: $e');
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al obtener ubicación: $e'),
              duration: const Duration(seconds: 3),
            ),
          );
        }
        return null;
      }
    }
    return null;
  }
}
