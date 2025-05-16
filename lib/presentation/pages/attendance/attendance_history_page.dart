import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_models/attendance_record_view_model.dart';
import '../../widgets/attendance/attendance_filter_widget.dart';
import '../../widgets/attendance/attendance_list_item.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../providers/providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';

class AttendanceHistoryPage extends ConsumerWidget {
  const AttendanceHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Obtener el usuario actual
    final currentUser = ref.watch(authProvider).user;
    final currentFilterState = ref.watch(attendanceFilterProvider);

    // Si es estudiante, forzar el filtro por su ID
    if (currentUser != null && currentUser.type == AppConstants.studentRole) {
      // Actualizar el filtro si no está establecido para el estudiante actual
      if (currentFilterState.studentId != currentUser.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref
              .read(attendanceFilterProvider.notifier)
              .updateFilter(
                currentFilterState.copyWith(studentId: currentUser.id),
              );
        });
      }
    }

    // Observar el estado de asistencia para actualizaciones
    final attendanceState = ref.watch(attendanceStateProvider);

    // Observar los registros filtrados
    final filteredRecords = ref.watch(
      filteredAttendanceRecordsProvider(
        AttendanceFilterParameters(
          studentId: currentFilterState.studentId,
          subjectId: currentFilterState.subjectId,
          date: currentFilterState.date,
        ),
      ),
    );

    // ignore: avoid_print
    print(
      'AttendanceHistoryPage rebuild - Last update: ${attendanceState.lastUpdate}',
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Historial de Asistencia',
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Actualizar Historial',
            onPressed: () {
              // Marcar para actualización y refrescar
              ref.read(attendanceStateProvider.notifier).markForRefresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Solo mostrar el filtro si es profesor
          if (currentUser?.type == AppConstants.teacherRole)
            const AttendanceFilterWidget(),
          Expanded(
            child: filteredRecords.when(
              loading: () => const CustomLoadingIndicator(),
              error: (error, stack) {
                // ignore: avoid_print
                print(
                  'Error in AttendanceHistoryPage (filteredAttendanceRecordsProvider): $error',
                );
                // ignore: avoid_print
                print(stack);
                return CustomErrorWidget(
                  message: 'Error al cargar historial: ${error.toString()}',
                );
              },
              data: (viewModels) {
                final filteredByEventType = _applyEventTypeFilter(
                  viewModels,
                  currentFilterState.eventType,
                );

                if (filteredByEventType.isEmpty) {
                  return const Center(
                    child: Text(
                      'No hay registros de asistencia que coincidan con los filtros.',
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: filteredByEventType.length,
                  itemBuilder: (context, index) {
                    final recordViewModel = filteredByEventType[index];
                    return AttendanceListItem(
                      record: recordViewModel,
                      onDelete:
                          (currentUser?.type == AppConstants.teacherRole &&
                                  recordViewModel.id != null)
                              ? (recordId) async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          'Confirmar Eliminación',
                                        ),
                                        content: const Text(
                                          '¿Estás seguro de que deseas eliminar este registro de asistencia?',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(false),
                                            child: const Text('Cancelar'),
                                          ),
                                          TextButton(
                                            onPressed:
                                                () => Navigator.of(
                                                  context,
                                                ).pop(true),
                                            child: const Text(
                                              'Eliminar',
                                              style: TextStyle(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                );

                                if (confirm == true) {
                                  try {
                                    // ignore: avoid_print
                                    print(
                                      'Attempting to delete record ID: $recordId',
                                    );
                                    await ref
                                        .read(deleteAttendanceRecordProvider)
                                        .call(recordId);

                                    // ignore: avoid_print
                                    print(
                                      'Record deleted, marking for refresh...',
                                    );
                                    // Marcar para actualización
                                    ref
                                        .read(attendanceStateProvider.notifier)
                                        .markForRefresh();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Registro eliminado.'),
                                          backgroundColor: Colors.green,
                                        ),
                                      );
                                    }
                                  } catch (e) {
                                    // ignore: avoid_print
                                    print(
                                      'Error deleting record ID $recordId: $e',
                                    );
                                    if (context.mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Error al eliminar: ${e.toString()}',
                                          ),
                                          backgroundColor: Colors.red,
                                        ),
                                      );
                                    }
                                  }
                                }
                              }
                              : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<AttendanceRecordViewModel> _applyEventTypeFilter(
    List<AttendanceRecordViewModel> viewModels,
    String eventType,
  ) {
    if (eventType == 'todos') {
      return viewModels;
    }
    // ignore: avoid_print
    print('Filtrando por tipo de evento: $eventType');
    return viewModels.where((vm) => vm.eventType == eventType).toList();
  }
}
