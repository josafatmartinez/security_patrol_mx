import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Nuevo: para controlar si se usa el tema del sistema o manual
  bool _useSystemTheme = true;
  bool get useSystemTheme => _useSystemTheme;

  // Claves para guardar preferencias en SharedPreferences
  static const String _themePreferenceKey = 'isDarkMode';
  static const String _useSystemThemeKey = 'useSystemTheme';

  ThemeController() {
    _loadThemePreference();
  }

  // Cargar las preferencias de tema guardadas
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _useSystemTheme =
        prefs.getBool(_useSystemThemeKey) ??
        true; // Por defecto usa el tema del sistema
    _isDarkMode = prefs.getBool(_themePreferenceKey) ?? false;
    notifyListeners();
  }

  // Guardar las preferencias de tema
  Future<void> _saveThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themePreferenceKey, _isDarkMode);
    await prefs.setBool(_useSystemThemeKey, _useSystemTheme);
  }

  // Cambiar el tema entre claro y oscuro
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    if (_useSystemTheme) {
      _useSystemTheme =
          false; // Al cambiar manualmente, desactivamos el tema del sistema
    }
    _saveThemePreference();
    notifyListeners();
  }

  // Establecer un tema específico
  void setDarkMode(bool value) {
    if (_isDarkMode != value) {
      _isDarkMode = value;
      if (_useSystemTheme) {
        _useSystemTheme =
            false; // Al cambiar manualmente, desactivamos el tema del sistema
      }
      _saveThemePreference();
      notifyListeners();
    }
  }

  // Nuevo: Toggle para usar el tema del sistema o no
  void toggleUseSystemTheme() {
    _useSystemTheme = !_useSystemTheme;
    _saveThemePreference();
    notifyListeners();
  }

  // Nuevo: Establecer si se usa el tema del sistema
  void setUseSystemTheme(bool value) {
    if (_useSystemTheme != value) {
      _useSystemTheme = value;
      _saveThemePreference();
      notifyListeners();
    }
  }
}
