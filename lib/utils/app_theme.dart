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

  // Método para obtener el tema dark completo
  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF90CAF9), // Azul más claro para dark mode
        onPrimary: Color(0xFF212121), // Texto sobre primary
        secondary: Color(0xFF81C784), // Verde más claro para dark mode
        onSecondary: Color(0xFF212121), // Texto sobre secondary
        error: Color(0xFFEF9A9A), // Rojo más claro para dark mode
        onError: Color(0xFF212121), // Texto claro sobre fondo oscuro
        surface: Color(0xFF1E1E1E), // Superficie oscura
        onSurface: Color(0xFFEEEEEE), // Texto claro sobre superficie
      ),
      // Configurar colores específicos para elementos de la aplicación
      scaffoldBackgroundColor: const Color(0xFF121212), // Fondo oscuro
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Color(0xFFEEEEEE),
        elevation: 2,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF90CAF9), // Azul más claro
          foregroundColor: const Color(0xFF212121), // Texto oscuro
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: const Color(0xFF90CAF9)),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFF90CAF9),
        foregroundColor: Color(0xFF212121),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: Color(0xFFEEEEEE)),
        displayMedium: TextStyle(color: Color(0xFFEEEEEE)),
        displaySmall: TextStyle(color: Color(0xFFEEEEEE)),
        headlineLarge: TextStyle(color: Color(0xFFEEEEEE)),
        headlineMedium: TextStyle(color: Color(0xFFEEEEEE)),
        headlineSmall: TextStyle(color: Color(0xFFEEEEEE)),
        titleLarge: TextStyle(color: Color(0xFFEEEEEE)),
        titleMedium: TextStyle(color: Color(0xFFEEEEEE)),
        titleSmall: TextStyle(color: Color(0xFFEEEEEE)),
        bodyLarge: TextStyle(color: Color(0xFFEEEEEE)),
        bodyMedium: TextStyle(color: Color(0xFFEEEEEE)),
        bodySmall: TextStyle(color: Color(0xFFEEEEEE)),
        labelLarge: TextStyle(color: Color(0xFFEEEEEE)),
        labelMedium: TextStyle(color: Color(0xFFEEEEEE)),
        labelSmall: TextStyle(color: Color(0xFFEEEEEE)),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1E1E),
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      iconTheme: const IconThemeData(color: Color(0xFFEEEEEE)),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade400;
          }
          return const Color(0xFF90CAF9);
        }),
        trackColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.disabled)) {
            return Colors.grey.shade700;
          }
          return const Color(0xFF90CAF9).withAlpha(128);
        }),
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
