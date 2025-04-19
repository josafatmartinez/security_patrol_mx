import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class WelcomeCard extends StatelessWidget {
  final User? user;
  final Function(String) onStatusButtonPressed;

  const WelcomeCard({
    super.key,
    required this.user,
    required this.onStatusButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenido, ${user?.name ?? "Guardia"}',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Fecha: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildStatusButton('Iniciar Turno', Colors.green),
                _buildStatusButton('Fin Turno', Colors.red),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButton(String text, Color color) {
    return ElevatedButton(
      onPressed: () => onStatusButtonPressed(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(text),
    );
  }
}
