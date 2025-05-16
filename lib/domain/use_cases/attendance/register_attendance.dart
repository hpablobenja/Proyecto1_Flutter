import '../../repositories/attendance_repository.dart';

class RegisterAttendance {
  final AttendanceRepository repository;

  RegisterAttendance(this.repository);

  Future<void> call({
    required String studentCode,
    required String subjectName,
    required String eventType,
  }) async {
    // El caso de uso simplemente coordina, pasando los datos al repositorio
    await repository.registerAttendance(studentCode, subjectName, eventType);
  }
}
