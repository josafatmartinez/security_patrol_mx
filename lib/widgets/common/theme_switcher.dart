import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);
    final Brightness platformBrightness = MediaQuery.platformBrightnessOf(
      context,
    );
    final bool isSystemDarkMode = platformBrightness == Brightness.dark;

    return Column(
      children: [
        // Opción para usar automáticamente el tema del sistema
        ListTile(
          title: const Text('Usar tema del sistema'),
          subtitle: const Text('Ajustar automáticamente según tu dispositivo'),
          trailing: Switch(
            value: themeController.useSystemTheme,
            onChanged: (value) {
              themeController.setUseSystemTheme(value);
            },
          ),
        ),

        // Opción para cambiar manualmente entre temas (deshabilitada si se usa el tema del sistema)
        Opacity(
          opacity: themeController.useSystemTheme ? 0.5 : 1.0,
          child: ListTile(
            title: const Text('Modo oscuro'),
            subtitle:
                themeController.useSystemTheme
                    ? Text(
                      'Actualmente ${isSystemDarkMode ? "activado" : "desactivado"} por el sistema',
                    )
                    : const Text(
                      'Cambiar manualmente entre modo claro y oscuro',
                    ),
            trailing: Switch(
              value:
                  themeController.useSystemTheme
                      ? isSystemDarkMode
                      : themeController.isDarkMode,
              onChanged:
                  themeController.useSystemTheme
                      ? null
                      : (value) {
                        themeController.setDarkMode(value);
                      },
            ),
          ),
        ),
      ],
    );
  }
}
