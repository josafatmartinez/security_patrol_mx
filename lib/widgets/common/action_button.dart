import 'package:flutter/material.dart';
import 'package:security_patrol_mx/utils/app_theme.dart';

class ActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final TextStyle? textStyle;
  final EdgeInsetsGeometry? padding;

  const ActionButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.textStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        padding: padding ?? const EdgeInsets.symmetric(vertical: 12),
      ),
      child:
          isLoading
              ? const CircularProgressIndicator()
              : Text(text, style: textStyle ?? const TextStyle(fontSize: 16)),
    );
  }
}
