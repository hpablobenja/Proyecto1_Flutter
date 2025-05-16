import 'package:flutter_riverpod/flutter_riverpod.dart';

// En lib/presentation/providers/attendance/attendance_filter_provider.dart
enum AttendanceRecordTypeFilter { all, entry, exit }

// ... el resto de tu provider AttendanceFilterState, AttendanceFilterNotifier, etc.

class AttendanceFilterState {
  final int? studentId;
  final int? subjectId;
  final DateTime? date;
  final String eventType; // 'todos', 'entry', 'exit'

  const AttendanceFilterState({
    this.studentId,
    this.subjectId,
    this.date,
    this.eventType = 'todos', // Default to 'todos'
  });

  AttendanceFilterState copyWith({
    int? studentId,
    bool clearStudentId = false,
    int? subjectId,
    bool clearSubjectId = false,
    DateTime? date,
    bool clearDate = false,
    String? eventType,
  }) {
    return AttendanceFilterState(
      studentId: clearStudentId ? null : studentId ?? this.studentId,
      subjectId: clearSubjectId ? null : subjectId ?? this.subjectId,
      date: clearDate ? null : date ?? this.date,
      eventType: eventType ?? this.eventType,
    );
  }
}

class AttendanceFilterNotifier extends StateNotifier<AttendanceFilterState> {
  AttendanceFilterNotifier() : super(const AttendanceFilterState());

  void updateFilter(AttendanceFilterState newState) {
    state = newState;
  }

  void setEventType(String eventType) {
    state = state.copyWith(eventType: eventType);
  }
}

final attendanceFilterProvider =
    StateNotifierProvider<AttendanceFilterNotifier, AttendanceFilterState>(
      (ref) => AttendanceFilterNotifier(),
    );
