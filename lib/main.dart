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

    return MaterialApp(
      title: 'Security Patrol',
      debugShowCheckedModeBanner: false,
      // Usa tema oscuro o claro según el estado del controlador
      theme:
          themeController.isDarkMode
              ? AppTheme.darkTheme()
              : AppTheme.lightTheme(),
      home: const LoginScreen(),
    );
  }
}
