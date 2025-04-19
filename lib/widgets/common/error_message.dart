import 'package:flutter/material.dart';
import 'package:security_patrol_mx/utils/app_theme.dart';

class ErrorMessage extends StatelessWidget {
  final String message;
  final TextStyle? style;
  final EdgeInsetsGeometry? padding;

  const ErrorMessage({
    super.key,
    required this.message,
    this.style,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(top: 16),
      child: Text(
        message,
        style: style ?? TextStyle(color: AppTheme.errorColor),
      ),
    );
  }
}
