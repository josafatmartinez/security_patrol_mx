import 'package:flutter/material.dart';

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
        style: style ?? TextStyle(color: Theme.of(context).colorScheme.error),
      ),
    );
  }
}
