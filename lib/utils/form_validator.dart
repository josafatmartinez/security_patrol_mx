/// Clase utilitaria para validación de formularios
class FormValidator {
  /// Valida un campo requerido
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese $fieldName';
    }
    return null;
  }

  /// Valida un correo electrónico
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el correo';
    }
    if (!value.contains('@')) {
      return 'Ingrese un correo válido';
    }
    return null;
  }

  /// Valida un teléfono
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor ingrese el teléfono';
    }
    return null;
  }

  /// Verifica si todos los campos en un mapa son válidos
  /// Las claves son los nombres de los campos y los valores son los mensajes de error
  /// Un campo es válido si su valor es null (sin mensaje de error)
  static bool areAllFieldsValid(Map<String, String?> fields) {
    return !fields.values.any((errorMessage) => errorMessage != null);
  }
}
