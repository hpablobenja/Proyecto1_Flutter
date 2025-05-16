// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\core\constants\database_constants.dart
import 'app_constants.dart';

class DatabaseConstants {
  // Nombre y versión de la base de datos
  static const String databaseName = 'tesla_college.db';
  static const int databaseVersion = 2; // Versión incrementada

  // Nombres de tablas
  static const String usersTable = 'users';
  static const String subjectsTable = 'subjects';
  static const String assignmentsTable = 'assignments';
  static const String attendanceTable = 'attendance_records';
  static const String historialAccionesTable =
      'historial_acciones'; // Si la usas

  // Columnas comunes
  static const String columnId = 'id';
  static const String columnCreatedAt = 'created_at';

  // Columnas de usuarios
  // static const String columnUserId = 'user_id'; // No parece usarse, id es suficiente
  static const String columnIdentificationCode = 'identification_code';
  static const String columnName = 'name';
  static const String columnType = 'type'; // 'Teacher' o 'Student'
  static const String columnQrCode = 'qr_code'; // Para estudiantes

  // Columnas de materias
  // static const String columnSubjectId = 'subject_id'; // No parece usarse, id es suficiente
  static const String columnSubjectName = 'name'; // Nombre de la materia
  static const String columnSchedule = 'schedule';

  // Columnas de asignaciones (tabla intermedia)
  static const String columnStudentId = 'student_id';
  static const String columnSubjectId =
      'subject_id'; // Aquí sí se usa para la relación

  // Columnas de asistencia
  static const String columnTimestamp = 'timestamp';
  static const String columnEventType = 'event_type'; // 'entry' o 'exit'
  // static const String columnIsPresent = 'is_present'; // Considerar si es necesario
  static const String columnIsDeleted = 'is_deleted'; // Nueva columna

  // Columnas de historial_acciones (si existe)
  static const String columnHistorialDescription = 'descripcion';
  static const String columnHistorialTimestamp = 'timestamp';

  // Sentencias SQL para creación de tablas
  static const String createUsersTable = '''
    CREATE TABLE $usersTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnIdentificationCode TEXT UNIQUE NOT NULL,
      $columnName TEXT NOT NULL,
      $columnType TEXT NOT NULL CHECK ($columnType IN ('${AppConstants.teacherRole}', '${AppConstants.studentRole}')),
      $columnQrCode TEXT,
      $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  static const String createSubjectsTable = '''
    CREATE TABLE $subjectsTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnSubjectName TEXT NOT NULL UNIQUE,
      $columnSchedule TEXT NOT NULL,
      $columnCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';

  static const String createAssignmentsTable = '''
    CREATE TABLE $assignmentsTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnStudentId INTEGER NOT NULL,
      $columnSubjectId INTEGER NOT NULL,
      FOREIGN KEY ($columnStudentId) REFERENCES $usersTable ($columnId) ON DELETE CASCADE,
      FOREIGN KEY ($columnSubjectId) REFERENCES $subjectsTable ($columnId) ON DELETE CASCADE,
      UNIQUE($columnStudentId, $columnSubjectId)
    )
  ''';

  static const String createAttendanceTable = '''
    CREATE TABLE $attendanceTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnStudentId INTEGER NOT NULL,
      $columnSubjectId INTEGER NOT NULL,
      $columnTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
      $columnEventType TEXT NOT NULL CHECK ($columnEventType IN ('${AppConstants.entryEvent}', '${AppConstants.exitEvent}')),
      FOREIGN KEY ($columnStudentId) REFERENCES $usersTable ($columnId) ON DELETE CASCADE,
      FOREIGN KEY ($columnSubjectId) REFERENCES $subjectsTable ($columnId) ON DELETE CASCADE
    )
  ''';

  // Sentencia para la tabla de historial de acciones (si la tienes)
  static const String createHistorialAccionesTable = '''
    CREATE TABLE $historialAccionesTable (
      $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnHistorialDescription TEXT NOT NULL,
      $columnHistorialTimestamp DATETIME DEFAULT CURRENT_TIMESTAMP
    )
  ''';
}
