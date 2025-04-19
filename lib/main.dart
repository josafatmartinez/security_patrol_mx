import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/auth/login_screen.dart';
import 'utils/app_theme.dart';
import 'services/theme_controller.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeController(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtiene el controlador de tema actual
    final themeController = Provider.of<ThemeController>(context);
    // Detecta el tema del sistema
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(
      context,
    );
    final bool isDarkModeSystem = platformBrightness == Brightness.dark;

    // Decide qué tema usar basado en las preferencias
    final bool useDarkTheme =
        themeController.useSystemTheme
            ? isDarkModeSystem
            : themeController.isDarkMode;

    return MaterialApp(
      title: 'Security Patrol',
      debugShowCheckedModeBanner: false,
      // Aplica el tema según la lógica actualizada
      theme: useDarkTheme ? AppTheme.darkTheme() : AppTheme.lightTheme(),
      home: const LoginScreen(),
    );
  }
}
