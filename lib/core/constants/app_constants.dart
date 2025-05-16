class AppConstants {
  static const String appName = 'Colegio Tecnológico Nikola Tesla';
  static const String appVersion = '1.0.0';

  static const String entryType =
      'entry'; // Or 'entrada' if that's what you store

  // Roles de usuario
  static const String teacherRole = 'Maestro';
  static const String studentRole = 'Estudiante';

  // Tipos de eventos de asistencia
  static const String entryEvent = 'entry';
  static const String exitEvent = 'exit';

  // Mensajes de validación
  static const String requiredField = 'Este campo es obligatorio';
  static const String invalidEmail = 'Ingrese un email válido';
  static const String minLengthError = 'Debe tener al menos {min} caracteres';

  // Tiempos
  static const Duration snackBarDuration = Duration(seconds: 3);
  static const Duration debounceTime = Duration(milliseconds: 500);

  // Estilos
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;
}
