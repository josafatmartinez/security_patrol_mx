import 'package:flutter/material.dart';
import '../../utils/app_theme.dart';

class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final String activeText;
  final String inactiveText;
  final double size;

  const StatusIndicator({
    super.key,
    required this.isActive,
    this.activeText = 'Activo',
    this.inactiveText = 'Inactivo',
    this.size = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.successColor;
    final inactiveColor = AppTheme.inactiveGuardColor;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: isActive ? activeColor : inactiveColor,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          isActive ? activeText : inactiveText,
          style: TextStyle(
            color: isActive ? activeColor : inactiveColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
