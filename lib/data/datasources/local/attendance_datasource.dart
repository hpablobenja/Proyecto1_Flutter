// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\data\datasources\local\attendance_datasource.dart
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../core/constants/database_constants.dart';
import '../../../domain/entities/attendance_record.dart';
import '../../../core/errors/exceptions.dart';

class AttendanceLocalDataSource {
  final Database db;

  AttendanceLocalDataSource(this.db);

  Future<void> registerAttendance({
    required String studentCode,
    required String subjectName,
    required String eventType,
  }) async {
    try {
      final studentResult = await db.query(
        DatabaseConstants.usersTable,
        columns: [DatabaseConstants.columnId],
        where: '${DatabaseConstants.columnIdentificationCode} = ?',
        whereArgs: [studentCode],
      );

      if (studentResult.isEmpty) {
        throw NotFoundException(
          'Estudiante no encontrado con código: $studentCode',
        );
      }
      final studentId = studentResult.first[DatabaseConstants.columnId] as int;

      final subjectResult = await db.query(
        DatabaseConstants.subjectsTable,
        columns: [DatabaseConstants.columnId],
        where: '${DatabaseConstants.columnSubjectName} = ?',
        whereArgs: [subjectName],
      );

      if (subjectResult.isEmpty) {
        throw NotFoundException(
          'Materia no encontrada con nombre: $subjectName',
        );
      }
      final subjectId = subjectResult.first[DatabaseConstants.columnId] as int;

      // VERIFICACIÓN DE QR REPETIDO EN 5 MIN (SOLO ACTIVOS)
      final fiveMinutesAgo = DateTime.now().subtract(
        const Duration(minutes: 5),
      );
      final recentActiveRecords = await db.query(
        DatabaseConstants.attendanceTable,
        where:
            '${DatabaseConstants.columnStudentId} = ? AND ${DatabaseConstants.columnSubjectId} = ? AND ${DatabaseConstants.columnEventType} = ? AND ${DatabaseConstants.columnTimestamp} > ?',
        whereArgs: [
          studentId,
          subjectId,
          eventType,
          fiveMinutesAgo.toIso8601String(),
        ],
        limit: 1,
      );

      if (recentActiveRecords.isNotEmpty) {
        throw ConflictException(
          'La asistencia para este estudiante en esta materia ya fue registrada hace menos de 5 minutos.',
        );
      }

      final Map<String, dynamic> recordMap = {
        DatabaseConstants.columnStudentId: studentId,
        DatabaseConstants.columnSubjectId: subjectId,
        DatabaseConstants.columnTimestamp: DateTime.now().toIso8601String(),
        DatabaseConstants.columnEventType: eventType,
      };

      await db.insert(
        DatabaseConstants.attendanceTable,
        recordMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on NotFoundException {
      rethrow;
    } on ConflictException {
      rethrow;
    } catch (e) {
      throw DatabaseException('Error al registrar asistencia: ${e.toString()}');
    }
  }

  Future<List<AttendanceRecord>> getAttendanceRecords({
    int? studentId,
    int? subjectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      final whereClauses = <String>[];
      final whereArgs = <dynamic>[];

      if (studentId != null) {
        whereClauses.add('${DatabaseConstants.columnStudentId} = ?');
        whereArgs.add(studentId);
      }
      if (subjectId != null) {
        whereClauses.add('${DatabaseConstants.columnSubjectId} = ?');
        whereArgs.add(subjectId);
      }
      if (fromDate != null) {
        whereClauses.add('${DatabaseConstants.columnTimestamp} >= ?');
        whereArgs.add(fromDate.toIso8601String());
      }
      if (toDate != null) {
        whereClauses.add('${DatabaseConstants.columnTimestamp} <= ?');
        whereArgs.add(toDate.toIso8601String());
      }

      final whereString =
          whereClauses.isNotEmpty ? whereClauses.join(' AND ') : null;

      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.attendanceTable,
        where: whereString,
        whereArgs: whereArgs,
        orderBy: '${DatabaseConstants.columnTimestamp} DESC',
      );

      // ignore: avoid_print
      print(
        'AttendanceLocalDataSource.getAttendanceRecords: Fetched ${maps.length} records.',
      );
      return List.generate(
        maps.length,
        (i) => AttendanceRecord.fromMap(maps[i]),
      );
    } catch (e) {
      throw DatabaseException(
        'Error al obtener registros de asistencia: ${e.toString()}',
      );
    }
  }

  Future<void> deleteAttendanceRecord(int recordId) async {
    try {
      final rowsAffected = await db.delete(
        DatabaseConstants.attendanceTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [recordId],
      );
      if (rowsAffected == 0) {
        throw NotFoundException(
          'Registro de asistencia no encontrado con ID: $recordId',
        );
      }
    } catch (e) {
      if (e is NotFoundException) rethrow;
      throw DatabaseException(
        'Error al eliminar el registro de asistencia: ${e.toString()}',
      );
    }
  }

  Future<AttendanceRecord?> getAttendanceRecordById(int id) async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.attendanceTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1,
      );
      if (maps.isNotEmpty) {
        return AttendanceRecord.fromMap(maps.first);
      }
    } catch (e) {
      throw DatabaseException(
        'Error al obtener registro de asistencia por ID: ${e.toString()}',
      );
    }
    return null;
  }
}
