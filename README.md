# Security Patrol MX 🛡️

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)

Una aplicación móvil para la gestión de rondines de seguridad y puntos de control. Diseñada específicamente para empresas de seguridad, condominios y organizaciones que requieren un monitoreo preciso de sus guardias de seguridad y puntos de control.

## 🚀 Características

### Para Guardias
- **Escaneo de QR**: Verificación de presencia en puntos específicos mediante códigos QR
- **Registro de Patrullas**: Inicio, seguimiento y finalización de rondines
- **Reporte de Incidentes**: Capacidad para informar anomalías durante el recorrido
- **Vista en Mapa**: Visualización de recorridos y ubicación de checkpoints

### Para Administradores/Comité
- **Gestión de Guardias**: Creación y administración de perfiles de guardias de seguridad
- **Configuración de Checkpoints**: Generación de puntos de control con códigos QR
- **Reportes y Estadísticas**: Análisis de rondines, visitas y rendimiento
- **Panel de Actividades**: Supervisión en tiempo real de todas las actividades

## 📱 Capturas de Pantalla

_Pantallas disponibles próximamente_

## 🛠️ Tecnologías Utilizadas

- **Framework**: Flutter
- **Lenguaje**: Dart
- **Geolocalización**: Geolocator
- **Mapas**: flutter_map
- **Escaneo QR**: mobile_scanner
- **Generación QR**: qr_flutter

## 📂 Estructura del Proyecto

```
lib/
├── main.dart             # Punto de entrada principal
├── models/               # Modelos de datos
│   ├── checkpoint_model.dart
│   ├── guard_model.dart
│   ├── patrol_model.dart
│   └── user_model.dart
├── screens/              # Pantallas de la aplicación
│   ├── auth/             # Autenticación
│   ├── checkpoint/       # Gestión de puntos de control
│   ├── home/             # Pantallas principales 
│   └── profile/          # Perfil de usuario
├── services/             # Servicios y lógica de negocio
│   ├── auth_service.dart
│   ├── checkpoint_service.dart
│   └── patrol_service.dart
├── utils/                # Utilidades y helpers
└── widgets/              # Widgets reutilizables
```

## 📝 Roles de Usuario

- **Guardia**: Acceso a escaneo de QR, reportes y rondines
- **Comité/Administrador**: Acceso completo a la gestión del sistema
- **Super Admin**: Capacidades administrativas extendidas

## ⚙️ Requisitos

- Flutter 3.0 o superior
- Dart 3.0 o superior
- Dispositivo con cámara (para escaneo de QR)
- Acceso a ubicación (para seguimiento GPS)

## 🔧 Instalación

1. Clona el repositorio
   ```bash
   git clone https://github.com/josafatmartinez/security_patrol_mx.git
   ```

2. Navega al directorio del proyecto
   ```bash
   cd security_patrol_mx
   ```

3. Instala las dependencias
   ```bash
   flutter pub get
   ```

4. Ejecuta la aplicación
   ```bash
   flutter run
   ```

## 🔒 Permisos Requeridos

- **Cámara**: Para escanear códigos QR de los checkpoints
- **Ubicación**: Para rastrear el recorrido durante las patrullas
- **Internet**: Para sincronización de datos (opcional según implementación)

## 📄 Licencia

Este proyecto está licenciado bajo la [Licencia MIT](LICENSE) - consulta el archivo LICENSE para más detalles.

## 👥 Contribución

Las contribuciones son bienvenidas. Para cambios importantes, abre primero un issue para discutir qué te gustaría cambiar.

## 📫 Contacto

V. Josafat C. Martinez - [josamtz@outlook.com](mailto:josamtz@outlook.com)

---

Desarrollado con ❤️ en México
