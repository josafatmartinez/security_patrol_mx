import 'package:flutter/material.dart';

class StatusSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color activeColor;
  final Color inactiveColor;
  final String activeText;
  final String inactiveText;

  const StatusSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeColor = Colors.green,
    this.inactiveColor = Colors.red,
    this.activeText = 'Activo',
    this.inactiveText = 'Inactivo',
  });

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(title),
      value: value,
      activeColor: activeColor,
      subtitle: Text(
        value ? activeText : inactiveText,
        style: TextStyle(color: value ? activeColor : inactiveColor),
      ),
      onChanged: onChanged,
    );
  }
}
