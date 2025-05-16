import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttendanceState {
  final bool needsRefresh;
  final DateTime? lastUpdate;

  AttendanceState({this.needsRefresh = false, this.lastUpdate});

  AttendanceState copyWith({bool? needsRefresh, DateTime? lastUpdate}) {
    return AttendanceState(
      needsRefresh: needsRefresh ?? this.needsRefresh,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

class AttendanceStateNotifier extends StateNotifier<AttendanceState> {
  AttendanceStateNotifier() : super(AttendanceState());

  void markForRefresh() {
    state = state.copyWith(needsRefresh: true, lastUpdate: DateTime.now());
  }

  void refreshCompleted() {
    state = state.copyWith(needsRefresh: false, lastUpdate: DateTime.now());
  }
}

final attendanceStateProvider =
    StateNotifierProvider<AttendanceStateNotifier, AttendanceState>((ref) {
      return AttendanceStateNotifier();
    });
