import '../../repositories/attendance_repository.dart';

class DeleteAttendanceRecord {
  final AttendanceRepository repository;

  DeleteAttendanceRecord(this.repository);

  Future<void> call(int recordId) async {
    return repository.deleteAttendanceRecord(recordId);
  }
}
