import 'package:flutter/material.dart';

/// Clase que define el tema y la paleta de colores de la aplicación
class AppTheme {
  // Colores principales
  static const Color primaryColor = Color(
    0xFF0D47A1,
  ); // Azul fuerte - Botones, encabezados
  static const Color secondaryColor = Color(
    0xFF4CAF50,
  ); // Verde éxito - Checkpoints completados
  static const Color warningColor = Color(
    0xFFFFC107,
  ); // Amarillo - Checkpoints pendientes
  static const Color errorColor = Color(
    0xFFD32F2F,
  ); // Rojo - Fallas, alertas, fuera de rango
  static const Color backgroundColor = Color(
    0xFFF5F5F5,
  ); // Gris claro - Fondo de pantalla
  static const Color textColor = Color(
    0xFF212121,
  ); // Negro casi puro - Legibilidad máxima

  // Método para obtener el tema light completo
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: Colors.white,
        onSurface: textColor,
      ),
      // Configurar colores específicos para elementos de la aplicación
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primaryColor),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(color: textColor),
        displayMedium: TextStyle(color: textColor),
        displaySmall: TextStyle(color: textColor),
        headlineLarge: TextStyle(color: textColor),
        headlineMedium: TextStyle(color: textColor),
        headlineSmall: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        bodySmall: TextStyle(color: textColor),
        labelLarge: TextStyle(color: textColor),
        labelMedium: TextStyle(color: textColor),
        labelSmall: TextStyle(color: textColor),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Colores para elementos específicos de la aplicación
  static const Color successColor = secondaryColor; // Éxito
  static const Color pendingColor = warningColor; // Pendiente
  static const Color inactiveColor = Colors.grey; // Inactivo

  // Colores para estados de checkpoint
  static const Color activeCheckpointColor = secondaryColor;
  static const Color pendingCheckpointColor = warningColor;
  static const Color inactiveCheckpointColor = Colors.grey;

  // Colores para estados de guardias
  static const Color activeGuardColor = secondaryColor;
  static const Color inactiveGuardColor = errorColor;
}
