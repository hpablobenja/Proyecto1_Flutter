import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'providers.dart'; // Para acceder a databaseProvider y historialDataProvider

// Estado para el HistorialNotifier, puede ser simple o más complejo si necesitas
// manejar estados de carga, error, etc., de forma más granular para las operaciones.
class HistorialOperationState {
  final bool isLoading;
  final String? error;

  HistorialOperationState({this.isLoading = false, this.error});

  HistorialOperationState copyWith({
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return HistorialOperationState(
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : error ?? this.error,
    );
  }
}

class HistorialNotifier extends StateNotifier<HistorialOperationState> {
  final Ref _ref;

  HistorialNotifier(this._ref) : super(HistorialOperationState());

  Future<bool> agregarEntradaHistorial(
    Map<String, dynamic> nuevaEntrada,
  ) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final db = _ref.read(databaseProvider);
      // Reemplaza 'historial_acciones' con el nombre de tu tabla.
      await db.insert('historial_acciones', nuevaEntrada);

      // ¡Importante! Invalida el provider para que se actualice la lista del historial.
      _ref.invalidate(historialDataProvider);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al añadir entrada: ${e.toString()}',
      );
      return false;
    }
  }

  Future<bool> borrarEntradaHistorial(int id) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final db = _ref.read(databaseProvider);
      // Reemplaza 'historial_acciones' y 'id' con los nombres correctos de tu tabla y columna ID.
      await db.delete('historial_acciones', where: 'id = ?', whereArgs: [id]);

      _ref.invalidate(historialDataProvider);
      state = state.copyWith(isLoading: false);
      return true;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error al borrar entrada: ${e.toString()}',
      );
      return false;
    }
  }
}

// Provider para el HistorialNotifier
final historialNotifierProvider =
    StateNotifierProvider<HistorialNotifier, HistorialOperationState>((ref) {
      return HistorialNotifier(ref);
    });
