import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../models/user_model.dart';
import '../../models/checkpoint_model.dart';
import '../../services/checkpoint_service.dart';

class ScanCheckpointScreen extends StatefulWidget {
  final User user;

  const ScanCheckpointScreen({super.key, required this.user});

  @override
  State<ScanCheckpointScreen> createState() => _ScanCheckpointScreenState();
}

class _ScanCheckpointScreenState extends State<ScanCheckpointScreen> {
  final CheckpointService _checkpointService = CheckpointService();
  final MobileScannerController _scannerController = MobileScannerController();

  bool _isProcessing = false;
  Checkpoint? _scannedCheckpoint;
  String? _errorMessage;
  final TextEditingController _notesController = TextEditingController();
  bool _hasIncident = false;

  @override
  void dispose() {
    _scannerController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _processCheckpoint(String qrData) async {
    if (_isProcessing) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final checkpoint = await _checkpointService.validateCheckpoint(qrData);

      setState(() {
        _isProcessing = false;
        _scannedCheckpoint = checkpoint;
        if (checkpoint == null) {
          _errorMessage =
              'Checkpoint no válido. El código QR no corresponde a un punto de control.';
        }
      });
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Error al validar el checkpoint: $e';
      });
    }
  }

  Future<void> _registerVisit() async {
    if (_scannedCheckpoint == null) return;

    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      await _checkpointService.registerVisit(
        checkpointId: _scannedCheckpoint!.id,
        guardId: widget.user.id ?? "",
        notes:
            _notesController.text.trim().isEmpty
                ? null
                : _notesController.text.trim(),
        hasIncident: _hasIncident,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('¡Visita registrada correctamente!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Regresa con resultado exitoso
      }
    } catch (e) {
      setState(() {
        _isProcessing = false;
        _errorMessage = 'Error al registrar la visita: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Checkpoint'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child:
            _scannedCheckpoint == null
                ? _buildScannerView()
                : _buildCheckpointDetails(),
      ),
    );
  }

  Widget _buildScannerView() {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: Container(
            margin: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: Colors.grey.shade300, width: 2.0),
            ),
            clipBehavior: Clip.antiAlias,
            child:
                _isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : MobileScanner(
                      controller: _scannerController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          if (barcode.rawValue != null) {
                            _processCheckpoint(barcode.rawValue!);
                            return;
                          }
                        }
                      },
                    ),
          ),
        ),
        if (_errorMessage != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Apunta la cámara hacia el código QR del punto de control',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton.filled(
                      onPressed: () => _scannerController.toggleTorch(),
                      icon: const Icon(Icons.flashlight_on),
                      tooltip: 'Linterna',
                    ),
                    IconButton.filled(
                      onPressed: () => _scannerController.switchCamera(),
                      icon: const Icon(Icons.flip_camera_ios),
                      tooltip: 'Cambiar cámara',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCheckpointDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 2.0,
            margin: const EdgeInsets.only(bottom: 24.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 28.0,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _scannedCheckpoint!.name,
                              style: const TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              _scannedCheckpoint!.location,
                              style: TextStyle(
                                fontSize: 16.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_scannedCheckpoint!.description != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        _scannedCheckpoint!.description!,
                        style: const TextStyle(fontSize: 16.0),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Text(
            'Detalles de la visita',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Notas (opcional)',
              border: OutlineInputBorder(),
              hintText: 'Añade observaciones sobre este punto de control...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16.0),
          SwitchListTile(
            title: const Text(
              '¿Hay incidencias?',
              style: TextStyle(fontSize: 16.0),
            ),
            subtitle: const Text(
              'Activa si hay alguna anomalía o situación que reportar',
            ),
            value: _hasIncident,
            activeColor: Colors.red,
            onChanged: (value) {
              setState(() {
                _hasIncident = value;
              });
            },
          ),
          const SizedBox(height: 24.0),
          SizedBox(
            width: double.infinity,
            child:
                _isProcessing
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      onPressed: _registerVisit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: const Text(
                        'REGISTRAR VISITA',
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ),
          ),
          const SizedBox(height: 16.0),
          if (_errorMessage != null)
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 16.0),
              textAlign: TextAlign.center,
            ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                setState(() {
                  _scannedCheckpoint = null;
                  _errorMessage = null;
                  _notesController.clear();
                  _hasIncident = false;
                });
              },
              child: const Text('ESCANEAR OTRO CHECKPOINT'),
            ),
          ),
        ],
      ),
    );
  }
}
