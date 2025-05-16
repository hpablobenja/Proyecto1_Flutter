import '../../repositories/attendance_repository.dart';
import '../../entities/attendance_record.dart';

class GetAttendanceRecords {
  final AttendanceRepository repository;

  GetAttendanceRecords(this.repository);

  Future<List<AttendanceRecord>> call({
    int? studentId,
    int? subjectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await repository.getAttendanceRecords(
      studentId: studentId,
      subjectId: subjectId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }
}
