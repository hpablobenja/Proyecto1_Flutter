class QRUtils {
  /// Genera el código QR para un estudiante en una materia específica
  static String generateQRCode(
    String studentId,
    String subjectName, {
    String eventType = 'entry',
  }) {
    // Usar ; como separador y asegurarse de que el nombre de la materia no contenga ;
    final sanitizedSubjectName = subjectName.replaceAll(';', '_');
    return '$studentId;$sanitizedSubjectName;$eventType';
  }

  /// Parsea el código QR escaneado y devuelve los componentes
  static Map<String, String>? parseQRCode(String qrData) {
    try {
      final parts = qrData.split(';');
      if (parts.length != 3) return null;

      return {
        'studentId': parts[0],
        'subjectName': parts[1],
        'eventType': parts[2],
      };
    } catch (e) {
      return null;
    }
  }

  /// Valida el formato del código QR
  static bool isValidQRCode(String qrData) {
    final parsed = parseQRCode(qrData);
    if (parsed == null) return false;

    // Validar que todos los campos requeridos estén presentes y no vacíos
    return parsed['studentId']?.isNotEmpty == true &&
        parsed['subjectName']?.isNotEmpty == true &&
        parsed['eventType']?.isNotEmpty == true;
  }

  /// Extrae el ID de estudiante del código QR
  static String? extractStudentId(String qrData) {
    return parseQRCode(qrData)?['studentId'];
  }

  /// Extrae el nombre de la materia del código QR
  static String? extractSubjectName(String qrData) {
    return parseQRCode(qrData)?['subjectName'];
  }

  /// Extrae el tipo de evento del código QR
  static String? extractEventType(String qrData) {
    return parseQRCode(qrData)?['eventType'];
  }
}
