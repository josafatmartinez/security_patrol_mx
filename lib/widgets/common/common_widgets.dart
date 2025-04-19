import 'package:flutter/material.dart';

export 'custom_text_field.dart';
export 'action_button.dart';
export 'error_message.dart';
export 'confirmation_dialog.dart';
export 'status_indicator.dart';
export 'detail_card.dart';
export 'status_switch_tile.dart';
export 'app_bottom_navigation_bar.dart';
export 'tab_navigator.dart';
export 'info_card.dart';

/// Widget reutilizable para mostrar diálogos de formulario
class FormDialog extends StatelessWidget {
  final String title;
  final List<Widget> formFields;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String cancelText;
  final String saveText;

  const FormDialog({
    super.key,
    required this.title,
    required this.formFields,
    required this.onCancel,
    required this.onSave,
    this.cancelText = 'Cancelar',
    this.saveText = 'Guardar',
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(mainAxisSize: MainAxisSize.min, children: formFields),
      ),
      actions: [
        TextButton(onPressed: onCancel, child: Text(cancelText)),
        TextButton(onPressed: onSave, child: Text(saveText)),
      ],
    );
  }
}
