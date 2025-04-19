import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/theme_controller.dart';

class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Provider.of<ThemeController>(context);

    return ListTile(
      title: const Text('Modo oscuro'),
      trailing: Switch(
        value: themeController.isDarkMode,
        onChanged: (value) {
          themeController.setDarkMode(value);
        },
      ),
    );
  }
}
