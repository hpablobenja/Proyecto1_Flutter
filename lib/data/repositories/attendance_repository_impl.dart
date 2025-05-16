// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\data\repositories\attendance_repository_impl.dart
import '../datasources/local/attendance_datasource.dart';
import '../../domain/entities/attendance_record.dart';
import '../../domain/repositories/attendance_repository.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceLocalDataSource localDataSource;

  AttendanceRepositoryImpl(this.localDataSource);

  @override
  Future<void> registerAttendance(
    String studentCode,
    String subjectName,
    String eventType,
  ) async {
    await localDataSource.registerAttendance(
      studentCode: studentCode,
      subjectName: subjectName,
      eventType: eventType,
    );
  }

  @override
  Future<List<AttendanceRecord>> getAttendanceRecords({
    int? studentId,
    int? subjectId,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    return await localDataSource.getAttendanceRecords(
      studentId: studentId,
      subjectId: subjectId,
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  @override
  Future<void> deleteAttendanceRecord(int recordId) async {
    await localDataSource.deleteAttendanceRecord(recordId);
  }
}
