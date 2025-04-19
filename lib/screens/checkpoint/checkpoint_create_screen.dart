import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../models/checkpoint_model.dart';
import '../../utils/form_validator.dart';
import '../../widgets/common/common_widgets.dart';
import 'dart:math' as math;

class CheckpointCreateScreen extends StatefulWidget {
  final Function(Checkpoint) onCheckpointCreated;

  const CheckpointCreateScreen({
    super.key,
    required this.onCheckpointCreated,
  });

  @override
  State<CheckpointCreateScreen> createState() => _CheckpointCreateScreenState();
}

class _CheckpointCreateScreenState extends State<CheckpointCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  
  String? _qrCodeData;
  bool _isGeneratingQR = false;

  @override
  void initState() {
    super.initState();
    // Use the device's location or a default location
    _latitudeController.text = '19.432608'; // Example: Mexico City latitude
    _longitudeController.text = '-99.133209'; // Example: Mexico City longitude
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _descriptionController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  void _generateQRCode() {
    if (_formKey.currentState!.validate()) {
      final checkpointId = 'CP${DateTime.now().millisecondsSinceEpoch}';
      
      final qrData = {
        'id': checkpointId,
        'name': _nameController.text,
        'location': _locationController.text,
        'lat': double.parse(_latitudeController.text),
        'lon': double.parse(_longitudeController.text),
        'timestamp': DateTime.now().toIso8601String(),
      };

      setState(() {
        _qrCodeData = qrData.toString();
        _isGeneratingQR = true;
      });
    }
  }

  void _saveCheckpoint() {
    if (_formKey.currentState!.validate() && _qrCodeData != null) {
      final checkpointId = 'CP${DateTime.now().millisecondsSinceEpoch}';
      
      final newCheckpoint = Checkpoint(
        id: checkpointId,
        name: _nameController.text,
        location: _locationController.text,
        description: _descriptionController.text.isEmpty ? null : _descriptionController.text,
        isActive: true,
        latitude: double.parse(_latitudeController.text),
        longitude: double.parse(_longitudeController.text),
        qrCode: _qrCodeData,
      );

      widget.onCheckpointCreated(newCheckpoint);
      Navigator.pop(context);
    } else if (_qrCodeData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero genera el código QR')),
      );
    }
  }

  void _getCurrentLocation() {
    // In a real app, you would use a location plugin like geolocator
    // For this example, we'll use random coordinates near Mexico City
    final random = math.Random();
    final lat = 19.4326 + (random.nextDouble() - 0.5) * 0.1;
    final lon = -99.1332 + (random.nextDouble() - 0.5) * 0.1;
    
    setState(() {
      _latitudeController.text = lat.toStringAsFixed(6);
      _longitudeController.text = lon.toStringAsFixed(6);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Checkpoint'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Información del Checkpoint',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              // Name field
              CustomTextField(
                controller: _nameController,
                labelText: 'Nombre del Checkpoint',
                prefixIcon: Icons.location_on,
                validator: (value) => FormValidator.validateRequired(value, 'el nombre'),
              ),
              const SizedBox(height: 16),
              
              // Location field
              CustomTextField(
                controller: _locationController,
                labelText: 'Ubicación',
                prefixIcon: Icons.map,
                validator: (value) => FormValidator.validateRequired(value, 'la ubicación'),
              ),
              const SizedBox(height: 16),
              
              // Description field
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Descripción (opcional)',
                prefixIcon: Icons.description,
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              
              // Coordinates section
              const Text(
                'Coordenadas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _latitudeController,
                      labelText: 'Latitud',
                      prefixIcon: Icons.north,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => FormValidator.validateNumber(value, 'la latitud'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _longitudeController,
                      labelText: 'Longitud',
                      prefixIcon: Icons.east,
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                      validator: (value) => FormValidator.validateNumber(value, 'la longitud'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Get current location button
              ElevatedButton.icon(
                onPressed: _getCurrentLocation,
                icon: const Icon(Icons.my_location),
                label: const Text('Obtener Ubicación Actual'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // QR Code section
              const Text(
                'Código QR',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              
              Center(
                child: _isGeneratingQR
                  ? Column(
                      children: [
                        QrImageView(
                          data: _qrCodeData!,
                          version: QrVersions.auto,
                          size: 200.0,
                          backgroundColor: Colors.white,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'ID: ${_qrCodeData!.substring(0, _qrCodeData!.indexOf(','))}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  : Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          'Presiona el botón para generar el código QR',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
              ),
              const SizedBox(height: 24),
              
              // Generate QR button
              ElevatedButton.icon(
                onPressed: _generateQRCode,
                icon: const Icon(Icons.qr_code),
                label: const Text('Generar Código QR'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 24),
              
              // Save button
              ElevatedButton.icon(
                onPressed: _saveCheckpoint,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Checkpoint'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}