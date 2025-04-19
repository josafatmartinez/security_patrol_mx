import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../../models/checkpoint_model.dart';
import '../../utils/form_validator.dart';
import '../../widgets/common/common_widgets.dart';
import 'dart:math' as math;

class CheckpointCreateScreen extends StatefulWidget {
  final Function(Checkpoint) onCheckpointCreated;

  const CheckpointCreateScreen({super.key, required this.onCheckpointCreated});

  @override
  State<CheckpointCreateScreen> createState() => _CheckpointCreateScreenState();
}

class _CheckpointCreateScreenState extends State<CheckpointCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _screenshotController = ScreenshotController();
  final _qrKey = GlobalKey();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();

  String? _qrCodeData;
  bool _isGeneratingQR = false;
  bool _isSavingQR = false;

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
        description:
            _descriptionController.text.isEmpty
                ? null
                : _descriptionController.text,
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

  Future<void> _downloadQRCode() async {
    if (!_isGeneratingQR || _qrCodeData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero genera el código QR')),
      );
      return;
    }

    setState(() {
      _isSavingQR = true;
    });

    try {
      // Solicitar permisos
      if (Platform.isAndroid) {
        final statuses = await [
          Permission.photos,
          Permission.mediaLibrary,
          Permission.storage,
        ].request();
        if (statuses.values.any((status) => !status.isGranted)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se requieren permisos para guardar el código QR'),
            ),
          );
          setState(() {
            _isSavingQR = false;
          });
          return;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Se requieren permisos para guardar el código QR'),
            ),
          );
          setState(() {
            _isSavingQR = false;
          });
          return;
        }
      }

      // Capturar la imagen del QR
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('No se pudo capturar la imagen');
      }

      // Crear un archivo temporal
      final tempDir = await getTemporaryDirectory();
      final String checkpointName = _nameController.text.replaceAll(' ', '_');
      final String fileName =
          'QR_${checkpointName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Guardar usando share plus (el usuario puede guardar desde el diálogo de compartir)
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Código QR del checkpoint: ${_nameController.text}',
        subject: 'Security Patrol MX - Código QR para imprimir',
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usa la opción "Guardar en dispositivo" para descargar el QR',
          ),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al procesar el código QR: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSavingQR = false;
      });
    }
  }

  Future<void> _shareQRCode() async {
    if (!_isGeneratingQR || _qrCodeData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero genera el código QR')),
      );
      return;
    }

    setState(() {
      _isSavingQR = true;
    });

    try {
      // Capturar la imagen del QR
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('No se pudo capturar la imagen');
      }

      // Crear un archivo temporal para compartir
      final tempDir = await getTemporaryDirectory();
      final String checkpointName = _nameController.text.replaceAll(' ', '_');
      final String fileName =
          'QR_${checkpointName}_${DateTime.now().millisecondsSinceEpoch}.png';
      final File file = File('${tempDir.path}/$fileName');
      await file.writeAsBytes(imageBytes);

      // Compartir el archivo
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Código QR para el checkpoint: ${_nameController.text}',
        subject: 'Security Patrol MX - Código QR',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al compartir el código QR: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSavingQR = false;
      });
    }
  }

  Future<void> _generatePDF() async {
    if (!_isGeneratingQR || _qrCodeData == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Primero genera el código QR')),
      );
      return;
    }

    setState(() {
      _isSavingQR = true;
    });

    try {
      // Capturar la imagen del QR
      final Uint8List? imageBytes = await _screenshotController.capture();
      if (imageBytes == null) {
        throw Exception('No se pudo capturar la imagen');
      }

      // Crear el documento PDF
      final pdf = pw.Document();
      final image = pw.MemoryImage(imageBytes);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Center(
              child: pw.Column(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    'Security Patrol MX',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Checkpoint: ${_nameController.text}',
                    style: pw.TextStyle(fontSize: 18),
                  ),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Ubicación: ${_locationController.text}',
                    style: pw.TextStyle(fontSize: 14),
                  ),
                  pw.SizedBox(height: 30),
                  pw.Image(image, width: 250, height: 250),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Fecha de generación: ${DateTime.now().toLocal().toString().split('.')[0]}',
                    style: pw.TextStyle(fontSize: 12, color: PdfColors.grey700),
                  ),
                ],
              ),
            );
          },
        ),
      );

      // Mostrar vista previa de impresión
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
        name: 'Checkpoint_${_nameController.text.replaceAll(' ', '_')}.pdf',
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al generar el PDF: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isSavingQR = false;
      });
    }
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Name field
              CustomTextField(
                controller: _nameController,
                labelText: 'Nombre del Checkpoint',
                prefixIcon: Icons.location_on,
                validator:
                    (value) =>
                        FormValidator.validateRequired(value, 'el nombre'),
              ),
              const SizedBox(height: 16),

              // Location field
              CustomTextField(
                controller: _locationController,
                labelText: 'Ubicación',
                prefixIcon: Icons.map,
                validator:
                    (value) =>
                        FormValidator.validateRequired(value, 'la ubicación'),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      controller: _latitudeController,
                      labelText: 'Latitud',
                      prefixIcon: Icons.north,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator:
                          (value) =>
                              FormValidator.validateNumber(value, 'la latitud'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomTextField(
                      controller: _longitudeController,
                      labelText: 'Longitud',
                      prefixIcon: Icons.east,
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator:
                          (value) => FormValidator.validateNumber(
                            value,
                            'la longitud',
                          ),
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
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              Center(
                child:
                    _isGeneratingQR
                        ? Screenshot(
                          controller: _screenshotController,
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            color: Colors.white,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                QrImageView(
                                  key: _qrKey,
                                  data: _qrCodeData!,
                                  version: QrVersions.auto,
                                  size: 200.0,
                                  backgroundColor: Colors.white,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${_nameController.text}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'ID: ${_qrCodeData!.substring(0, _qrCodeData!.indexOf(','))}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
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

              // Download QR button - only show when QR is generated
              if (_isGeneratingQR) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isSavingQR ? null : _downloadQRCode,
                  icon:
                      _isSavingQR
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.download),
                  label: Text(
                    _isSavingQR ? 'Guardando...' : 'Descargar QR para imprimir',
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isSavingQR ? null : _shareQRCode,
                  icon:
                      _isSavingQR
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.share),
                  label: Text(_isSavingQR ? 'Compartiendo...' : 'Compartir QR'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _isSavingQR ? null : _generatePDF,
                  icon:
                      _isSavingQR
                          ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                          : const Icon(Icons.picture_as_pdf),
                  label: Text(_isSavingQR ? 'Generando PDF...' : 'Generar PDF'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
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
