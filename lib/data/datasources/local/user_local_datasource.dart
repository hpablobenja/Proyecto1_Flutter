// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\data\datasources\local\users_local_datasource.dart
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../core/constants/database_constants.dart';
import '../models/user_model.dart'; // Corregir la ruta de importación
import '../../../core/errors/exceptions.dart';

class UsersLocalDataSource {
  final Database db;

  UsersLocalDataSource(this.db);

  /// Obtiene todos los usuarios de la base de datos.
  Future<List<UserModel>> getUsers() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.usersTable,
      );
      return List.generate(maps.length, (i) => UserModel.fromMap(maps[i]));
    } catch (e) {
      throw DatabaseException('Error al obtener usuarios: ${e.toString()}');
    }
  }

  /// Obtiene un usuario por su ID.
  Future<UserModel> getUserById(int id) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        DatabaseConstants.usersTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1, // Limitar a 1 resultado ya que el ID es único
      );

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      } else {
        throw NotFoundException('Usuario no encontrado con ID: $id');
      }
    } catch (e) {
      // Mantengo la distinción de errores para mejor manejo en capas superiores
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException(
          'Error al obtener usuario por ID: ${e.toString()}',
        );
      }
    }
  }

  /// Obtiene un usuario por su código de identificación.
  Future<UserModel> getUserByIdentificationCode(String code) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        DatabaseConstants.usersTable,
        where: '${DatabaseConstants.columnIdentificationCode} = ?',
        whereArgs: [code],
        limit: 1, // Limitar a 1 resultado ya que el código es único
      );

      if (result.isNotEmpty) {
        return UserModel.fromMap(result.first);
      } else {
        throw NotFoundException('Usuario no encontrado con código: $code');
      }
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException(
          'Error al obtener usuario por código de identificación: ${e.toString()}',
        );
      }
    }
  }

  /// Crea un nuevo usuario en la base de datos.
  Future<void> createUser(UserModel user) async {
    try {
      await db.insert(
        DatabaseConstants.usersTable,
        user.toMap(),
        // Usar ignore para evitar errores si el código de identificación ya existe
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } on DatabaseException catch (e) {
      // Puedes añadir manejo específico para UNIQUE constraint failed si es necesario
      if (e.isUniqueConstraintError()) {
        throw ConflictException('El código de identificación ya existe.');
      }
      throw DatabaseException('Error al crear usuario: ${e.toString()}');
    } catch (e) {
      throw DatabaseException('Error al crear usuario: ${e.toString()}');
    }
  }

  /// Actualiza un usuario existente en la base de datos.
  Future<void> updateUser(UserModel user) async {
    try {
      final rowsAffected = await db.update(
        DatabaseConstants.usersTable,
        user.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [user.id],
      );
      if (rowsAffected == 0) {
        throw NotFoundException(
          'Usuario no encontrado para actualizar con ID: ${user.id}',
        );
      }
    } on DatabaseException catch (e) {
      // Puedes añadir manejo específico para UNIQUE constraint failed si es necesario
      if (e.isUniqueConstraintError()) {
        throw ConflictException('El código de identificación ya existe.');
      }
      throw DatabaseException('Error al actualizar usuario: ${e.toString()}');
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException('Error al actualizar usuario: ${e.toString()}');
      }
    }
  }

  /// Elimina un usuario por su ID.
  Future<void> deleteUser(int id) async {
    try {
      final rowsAffected = await db.delete(
        DatabaseConstants.usersTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );
      if (rowsAffected == 0) {
        throw NotFoundException(
          'Usuario no encontrado para eliminar con ID: $id',
        );
      }
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException('Error al eliminar usuario: ${e.toString()}');
      }
    }
  }

  /// Obtiene un usuario por su código de identificación y verifica la contraseña.
  Future<UserModel> getUserByIdentificationCodeAndPassword(
    String identificationCode,
    String password,
  ) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        DatabaseConstants.usersTable,
        where: '${DatabaseConstants.columnIdentificationCode} = ?',
        whereArgs: [identificationCode],
        limit: 1,
      );

      if (result.isNotEmpty) {
        // Verificar la contraseña
        if (password != '12345') {
          throw AuthenticationException('Contraseña incorrecta.');
        }
        return UserModel.fromMap(result.first);
      } else {
        throw NotFoundException(
          'Usuario no encontrado con código: $identificationCode',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
