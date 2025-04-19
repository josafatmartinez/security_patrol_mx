import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String confirmText;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final IconData? confirmIcon;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    this.cancelText = 'Cancelar',
    this.confirmText = 'Confirmar',
    required this.onConfirm,
    this.confirmColor,
    this.confirmIcon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
          style:
              confirmColor != null
                  ? TextButton.styleFrom(foregroundColor: confirmColor)
                  : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (confirmIcon != null) Icon(confirmIcon, size: 16),
              if (confirmIcon != null) const SizedBox(width: 8),
              Text(confirmText),
            ],
          ),
        ),
      ],
    );
  }
}
