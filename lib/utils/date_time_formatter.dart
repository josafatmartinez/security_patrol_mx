class DateTimeFormatter {
  // Formatea una fecha para mostrarla de manera amigable (hoy, ayer, o fecha completa)
  static String formatRelative(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      // Hoy
      return 'Hoy, ${_formatTimeOfDay(dateTime)}';
    } else if (difference.inDays == 1) {
      // Ayer
      return 'Ayer, ${_formatTimeOfDay(dateTime)}';
    } else {
      // Otro día
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}, ${_formatTimeOfDay(dateTime)}';
    }
  }

  // Formatea solo la hora y minutos con padding para minutos
  static String _formatTimeOfDay(DateTime dateTime) {
    return '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Formatea fecha corta
  static String formatShortDate(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  // Formatea fecha y hora completas
  static String formatFull(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTimeOfDay(dateTime)}';
  }

  // Formatea fecha y hora para mostrar en la UI
  static String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${_formatTimeOfDay(dateTime)}';
  }
}
