class ValidationUtils {
  /// Valida que el campo no esté vacío
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.isEmpty) {
      return fieldName != null
          ? '$fieldName es obligatorio'
          : 'Este campo es obligatorio';
    }
    return null;
  }

  /// Valida un código de identificación (ej: STD001, TCH005)
  static String? validateIdentificationCode(String? value) {
    if (validateRequired(value) != null) return validateRequired(value);

    final regex = RegExp(r'^[A-Z]{3}\d{3}$');
    if (!regex.hasMatch(value!)) {
      return 'Formato inválido (ej: STD001)';
    }
    return null;
  }

  /// Valida un nombre (solo letras y espacios)
  static String? validateName(String? value) {
    if (validateRequired(value, fieldName: 'El nombre') != null) {
      return validateRequired(value, fieldName: 'El nombre');
    }

    final regex = RegExp(r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+$');
    if (!regex.hasMatch(value!)) {
      return 'Solo se permiten letras y espacios';
    }
    return null;
  }

  /// Valida un horario (ej: "Lunes 8:00-10:00")
  static String? validateSchedule(String? value) {
    if (validateRequired(value, fieldName: 'El horario') != null) {
      return validateRequired(value, fieldName: 'El horario');
    }

    final regex = RegExp(
      r'^[a-zA-ZáéíóúÁÉÍÓÚñÑ\s]+\s\d{1,2}:\d{2}-\d{1,2}:\d{2}$',
    );
    if (!regex.hasMatch(value!)) {
      return 'Formato inválido (ej: "Lunes 8:00-10:00")';
    }
    return null;
  }

  /// Valida una selección de tipo (dropdown)
  static String? validateType(String? value, List<String> validOptions) {
    if (value == null || !validOptions.contains(value)) {
      return 'Seleccione una opción válida';
    }
    return null;
  }

  /// Valida la longitud mínima de un texto
  static String? validateMinLength(String? value, int minLength) {
    if (value == null || value.length < minLength) {
      return 'Debe tener al menos $minLength caracteres';
    }
    return null;
  }

  /// Combina múltiples validadores
  static String? validateAll(List<String? Function()> validators) {
    for (final validator in validators) {
      final error = validator();
      if (error != null) return error;
    }
    return null;
  }
}
