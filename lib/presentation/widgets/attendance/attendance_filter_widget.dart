import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/attendance/attendance_filter_provider.dart';

class AttendanceFilterWidget extends ConsumerWidget {
  const AttendanceFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(attendanceFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Mostrar: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          DropdownButton<String>(
            value: filterState.eventType,
            items: [
              const DropdownMenuItem(value: 'todos', child: Text('TODOS')),
              DropdownMenuItem(
                value: AppConstants.entryEvent,
                child: const Text('ENTRADAS'),
              ),
              DropdownMenuItem(
                value: AppConstants.exitEvent,
                child: const Text('SALIDAS'),
              ),
            ],
            onChanged: (newValue) {
              if (newValue != null) {
                ref
                    .read(attendanceFilterProvider.notifier)
                    .setEventType(newValue);
              }
            },
          ),
        ],
      ),
    );
  }
}
