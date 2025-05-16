import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/entities/user.dart';
import '../../../presentation/providers/auth_provider.dart';
import '../../../presentation/providers/providers.dart'; // Para deleteAttendanceRecordProvider y attendanceListProvider
import '../../view_models/attendance_record_view_model.dart';

class AttendanceListItem extends ConsumerWidget {
  final AttendanceRecordViewModel record;
  final Future<void> Function(int recordId)? onDelete;

  const AttendanceListItem({super.key, required this.record, this.onDelete});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.user;

    final DateFormat dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ListTile(
        leading: Icon(
          record.eventType == AppConstants.entryType
              ? Icons.input
              : Icons.output,
          color:
              record.eventType == AppConstants.entryType
                  ? Colors.green
                  : Colors.orange,
        ),
        title: Text(
          '${record.studentName ?? 'Estudiante Desconocido'} - ${record.subjectName ?? 'Materia Desconocida'}',
        ),
        subtitle: Text(
          '${record.eventType == AppConstants.entryType ? "Entrada" : "Salida"} - ${dateTimeFormatter.format(record.timestamp)}',
        ),
        isThreeLine: true,
        trailing:
            (currentUser?.type == AppConstants.teacherRole && record.id != null)
                ? IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[700]),
                  tooltip: 'Eliminar permanentemente',
                  onPressed: () async {
                    final confirmDelete = await showDialog<bool>(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirmar Eliminación'),
                          content: const Text(
                            '¿Estás seguro de que deseas eliminar este registro de asistencia? Esta acción no se puede deshacer.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('Cancelar'),
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                            ),
                            TextButton(
                              child: const Text(
                                'Eliminar',
                                style: TextStyle(color: Colors.red),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (confirmDelete == true) {
                      try {
                        if (onDelete != null) {
                          // ignore: avoid_print
                          print(
                            'AttendanceListItem: Calling onDelete callback for record ID ${record.id}',
                          );
                          await onDelete!(record.id!);
                        } else {
                          // ignore: avoid_print
                          print(
                            'AttendanceListItem: Handling delete directly for record ID ${record.id}',
                          );
                          await ref
                              .read(deleteAttendanceRecordProvider)
                              .call(record.id!);
                          // Usar ref.refresh para FutureProvider
                          ref.refresh(attendanceListProvider);
                        }
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Registro eliminado permanentemente',
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        }
                      } catch (e) {
                        // ignore: avoid_print
                        print(
                          'AttendanceListItem: Error deleting record ID ${record.id}: $e',
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
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
                  },
                )
                : null,
      ),
    );
  }
}
