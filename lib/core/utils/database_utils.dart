import 'package:sqflite/sqflite.dart';

class DatabaseUtils {
  /// Convierte un Map de datos de SQLite a un tipo específico
  static T mapToEntity<T>(
    Map<String, dynamic> map,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return fromMap(map);
  }

  /// Convierte una lista de Maps a una lista de entidades
  static List<T> mapListToEntities<T>(
    List<Map<String, dynamic>> maps,
    T Function(Map<String, dynamic>) fromMap,
  ) {
    return maps.map((map) => mapToEntity(map, fromMap)).toList();
  }

  /// Maneja errores comunes de SQLite
  static Future<T> handleDatabaseOperation<T>(Future<T> operation()) async {
    try {
      return await operation();
    } on DatabaseException catch (e) {
      throw _parseDatabaseException(e);
    } catch (e) {
      throw 'Error inesperado en la base de datos: ${e.toString()}';
    }
  }

  static String _parseDatabaseException(DatabaseException e) {
    if (e.isUniqueConstraintError()) {
      return 'El registro ya existe';
    } else if (e.isNoSuchTableError()) {
      return 'Tabla no encontrada';
    } else {
      return 'Error de base de datos: ${e.toString()}';
    }
  }
}

extension DatabaseExceptionExtensions on DatabaseException {
  bool isUniqueConstraintError() {
    return toString().contains('UNIQUE constraint failed');
  }

  bool isNoSuchTableError() {
    return toString().contains('no such table');
  }
}
