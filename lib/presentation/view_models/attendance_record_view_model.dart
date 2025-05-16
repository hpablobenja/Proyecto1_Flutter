import '../../domain/entities/attendance_record.dart';

/// ViewModel para mostrar registros de asistencia con nombres de estudiante y materia.
class AttendanceRecordViewModel {
  final int? id;
  final int studentId;
  final String studentName;
  final int subjectId;
  final String subjectName;
  final DateTime timestamp;
  final String eventType;

  AttendanceRecordViewModel({
    this.id,
    required this.studentId,
    required this.studentName,
    required this.subjectId,
    required this.subjectName,
    required this.timestamp,
    required this.eventType,
  });

  /// Crea un ViewModel a partir de una entidad AttendanceRecord y los nombres resueltos.
  factory AttendanceRecordViewModel.fromAttendanceRecord({
    required AttendanceRecord record,
    required String studentName,
    required String subjectName,
  }) {
    return AttendanceRecordViewModel(
      id: record.id,
      studentId: record.studentId,
      studentName: studentName,
      subjectId: record.subjectId,
      subjectName: subjectName,
      timestamp: record.timestamp,
      eventType: record.eventType,
    );
  }
}
