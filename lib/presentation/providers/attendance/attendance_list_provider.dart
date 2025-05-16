import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/attendance_record.dart';
import '../providers.dart'; // Importa el archivo central de providers

final attendanceListProvider = FutureProvider<List<AttendanceRecord>>((
  ref,
) async {
  // Observar el estado de asistencia para forzar la actualización
  final attendanceState = ref.watch(attendanceStateProvider);

  // ignore: avoid_print
  print(
    'attendanceListProvider: Fetching records... Last update: ${attendanceState.lastUpdate}',
  );

  final getAttendanceRecords = ref.read(getAttendanceRecordsProvider);
  return await getAttendanceRecords();
});
