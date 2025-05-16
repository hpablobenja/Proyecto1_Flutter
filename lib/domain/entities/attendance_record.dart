// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\domain\entities\attendance_record.dart
class AttendanceRecord {
  final int? id;
  final int studentId;
  final int subjectId;
  final DateTime timestamp;
  final String eventType; // 'entry' o 'exit'

  AttendanceRecord({
    this.id,
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

  factory AttendanceRecord.fromMap(Map<String, dynamic> map) {
    return AttendanceRecord(
      id: map['id'] as int?,
      studentId: map['student_id'] as int,
      subjectId: map['subject_id'] as int,
      timestamp: DateTime.parse(map['timestamp'] as String),
      eventType: map['event_type'] as String,
    );
  }
}
