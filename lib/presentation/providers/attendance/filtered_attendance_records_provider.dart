import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/attendance_record.dart';
import '../../view_models/attendance_record_view_model.dart';
import '../subjects/subjects_list_provider.dart';
import '../users/users_list_provider.dart';
import 'attendance_list_provider.dart'; // Assuming this provides List<AttendanceRecord>

// Define a class for the family parameters to ensure proper provider caching and updates
class AttendanceFilterParameters {
  final int? subjectId;
  final int? studentId;
  final DateTime? date;

  AttendanceFilterParameters({this.subjectId, this.studentId, this.date});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AttendanceFilterParameters &&
          runtimeType == other.runtimeType &&
          subjectId == other.subjectId &&
          studentId == other.studentId &&
          date == other.date;

  @override
  int get hashCode => subjectId.hashCode ^ studentId.hashCode ^ date.hashCode;
}

final filteredAttendanceRecordsProvider = FutureProvider.family<
  List<AttendanceRecordViewModel>,
  AttendanceFilterParameters
>((ref, params) async {
  // Fetch all necessary data
  // Use .future to await the FutureProvider's result
  final allAttendanceRecords = await ref.watch(attendanceListProvider.future);
  final allStudents = await ref.watch(usersListProvider.future);
  final allSubjects = await ref.watch(subjectsListProvider.future);

  // ignore: avoid_print
  print(
    'filteredAttendanceRecordsProvider: Processing ${allAttendanceRecords.length} records with filters',
  );

  // Create maps for quick lookup of names
  final studentMap = {
    for (var student in allStudents) student.id: student.name,
  };
  final subjectMap = {
    for (var subject in allSubjects) subject.id: subject.name,
  };

  // Filter attendance records
  List<AttendanceRecord> filteredRecords =
      allAttendanceRecords.where((record) {
        bool matchesSubject =
            params.subjectId == null || record.subjectId == params.subjectId;
        bool matchesStudent =
            params.studentId == null || record.studentId == params.studentId;
        bool matchesDate =
            params.date == null ||
            (record.timestamp.year == params.date!.year &&
                record.timestamp.month == params.date!.month &&
                record.timestamp.day == params.date!.day);
        return matchesSubject && matchesStudent && matchesDate;
      }).toList();

  // Map to ViewModel
  return filteredRecords.map((record) {
    return AttendanceRecordViewModel.fromAttendanceRecord(
      record: record,
      studentName: studentMap[record.studentId] ?? 'Estudiante Desconocido',
      subjectName: subjectMap[record.subjectId] ?? 'Materia Desconocida',
    );
  }).toList();
});
