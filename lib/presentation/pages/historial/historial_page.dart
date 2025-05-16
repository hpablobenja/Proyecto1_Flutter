import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proyecto_final/presentation/providers/providers.dart'; // Importa tus providers

class HistorialPage extends ConsumerWidget {
  const HistorialPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Observa el provider de datos del historial
    final asyncHistorialData = ref.watch(historialDataProvider);

    // 2. Observa el estado del notifier para mostrar errores de operación si es necesario
    //    y para escuchar cambios si quieres mostrar SnackBars de forma reactiva.
    ref.listen<HistorialOperationState>(historialNotifierProvider, (
      previous,
      next,
    ) {
      if (next.error != null &&
          (previous?.error != next.error || previous?.isLoading == true)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error!), backgroundColor: Colors.red),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Acciones')),
      body: asyncHistorialData.when(
        data: (listaHistorial) {
          if (listaHistorial.isEmpty) {
            return const Center(
              child: Text('No hay acciones en el historial.'),
            );
          }
          return ListView.builder(
            itemCount: listaHistorial.length,
            itemBuilder: (context, index) {
              final item = listaHistorial[index];
              // Asume que tu tabla 'historial_acciones' tiene columnas 'id' y 'descripcion'.
              // Ajusta según tu estructura.
              final itemId =
                  item['id']
                      as int?; // El ID podría ser nulo si no se define como NOT NULL y AUTOINCREMENT
              final itemDescripcion = item['descripcion'] as String? ?? 'N/A';
              final itemTimestamp =
                  item['timestamp']
                      as String?; // Asume que tienes una columna timestamp

              return ListTile(
                title: Text(itemDescripcion),
                subtitle: Text(
                  'ID: ${itemId ?? "Sin ID"}${itemTimestamp != null ? " - $itemTimestamp" : ""}',
                ),
                trailing:
                    itemId != null
                        ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder:
                                  (context) => AlertDialog(
                                    title: const Text('Confirmar eliminación'),
                                    content: Text(
                                      '¿Seguro que quieres eliminar la entrada "$itemDescripcion"?',
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
                                            () =>
                                                Navigator.of(context).pop(true),
                                        child: const Text(
                                          'Eliminar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                    ],
                                  ),
                            );

                            if (confirm == true) {
                              // Llama al método de borrar del notifier
                              final success = await ref
                                  .read(historialNotifierProvider.notifier)
                                  .borrarEntradaHistorial(itemId);
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Entrada "$itemDescripcion" borrada.',
                                    ),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              }
                            }
                          },
                        )
                        : null,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          // Esto es para errores al cargar la lista inicial
          return Center(child: Text('Error al cargar el historial: $error'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Ejemplo de cómo añadir una nueva entrada
          // Podrías abrir un diálogo para que el usuario ingrese la descripción.
          final nuevaEntrada = {
            // 'id' usualmente es autoincremental, no necesitas pasarlo al insertar.
            'descripcion':
                'Nueva acción registrada a las ${TimeOfDay.now().format(context)}',
            'timestamp':
                DateTime.now().toIso8601String(), // Ejemplo de timestamp
            // Añade otros campos según tu tabla 'historial_acciones'
          };
          final success = await ref
              .read(historialNotifierProvider.notifier)
              .agregarEntradaHistorial(nuevaEntrada);

          if (success && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nueva entrada añadida al historial.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: const Icon(Icons.add),
        tooltip: 'Añadir entrada al historial',
      ),
    );
  }
}
