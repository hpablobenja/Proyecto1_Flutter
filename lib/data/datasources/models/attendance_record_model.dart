import 'package:sqflite/sqflite.dart';

class AttendanceRecordModel {
  final int id;
  final int studentId;
  final int subjectId;
  final DateTime timestamp;
  final String eventType;

  AttendanceRecordModel({
    required this.id,
    required this.studentId,
    required this.subjectId,
    required this.timestamp,
    required this.eventType,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'student_id': studentId,
      'subject_id': subjectId,
      'timestamp': timestamp.toIso8601String(),
      'event_type': eventType,
    };
  }

  static AttendanceRecordModel fromMap(Map<String, dynamic> map) {
    return AttendanceRecordModel(
      id: map['id'],
      studentId: map['student_id'],
      subjectId: map['subject_id'],
      timestamp: DateTime.parse(map['timestamp']),
      eventType: map['event_type'],
    );
  }
}
