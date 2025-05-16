// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\domain\repositories\attendance_repository.dart
import '../entities/attendance_record.dart';

abstract class AttendanceRepository {
  Future<void> registerAttendance(
    String studentCode,
    String subjectName,
    String eventType,
  );
  Future<List<AttendanceRecord>> getAttendanceRecords({
    int? studentId,
    int? subjectId,
    DateTime? fromDate,
    DateTime? toDate,
  });
  Future<void> deleteAttendanceRecord(int recordId);
}
