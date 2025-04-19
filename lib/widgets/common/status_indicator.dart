import 'package:flutter/material.dart';

class StatusIndicator extends StatelessWidget {
  final bool isActive;
  final String activeText;
  final String inactiveText;
  final Color activeColor;
  final Color inactiveColor;
  final double size;

  const StatusIndicator({
    super.key,
    required this.isActive,
    this.activeText = 'Activo',
    this.inactiveText = 'Inactivo',
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.red,
    this.size = 10.0,
  });

  @override
  Widget build(BuildContext context) {
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
