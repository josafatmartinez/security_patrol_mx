import 'package:flutter/material.dart';
import 'package:security_patrol_mx/utils/app_theme.dart';

class StatusSwitchTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String activeText;
  final String inactiveText;

  const StatusSwitchTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.activeText = 'Activo',
    this.inactiveText = 'Inactivo',
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = AppTheme.successColor;
    final inactiveColor = AppTheme.errorColor;

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
