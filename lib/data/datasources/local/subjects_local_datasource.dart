// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\data\datasources\local\subjects_local_datasource.dart
import 'package:sqflite/sqflite.dart' hide DatabaseException;
import '../../../core/constants/database_constants.dart';
import '../../models/subject_model.dart'; // Asegúrate de usar el modelo si tienes uno, o la entidad directamente
import '../../../core/errors/exceptions.dart';

class SubjectsLocalDataSource {
  final Database db;

  SubjectsLocalDataSource(this.db);

  /// Obtiene todas las materias de la base de datos.
  Future<List<SubjectModel>> getSubjects() async {
    try {
      final List<Map<String, dynamic>> maps = await db.query(
        DatabaseConstants.subjectsTable,
      );
      return List.generate(maps.length, (i) => SubjectModel.fromMap(maps[i]));
    } catch (e) {
      throw DatabaseException('Error al obtener materias: ${e.toString()}');
    }
  }

  /// Obtiene una materia por su ID.
  Future<SubjectModel> getSubjectById(int id) async {
    try {
      final List<Map<String, dynamic>> result = await db.query(
        DatabaseConstants.subjectsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
        limit: 1, // Limitar a 1 resultado ya que el ID es único
      );

      if (result.isNotEmpty) {
        return SubjectModel.fromMap(result.first);
      } else {
        throw NotFoundException('Materia no encontrada con ID: $id');
      }
    } catch (e) {
      // Mantengo la distinción de errores para mejor manejo en capas superiores
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException(
          'Error al obtener materia por ID: ${e.toString()}',
        );
      }
    }
  }

  /// Crea una nueva materia en la base de datos.
  Future<void> createSubject(SubjectModel subject) async {
    try {
      await db.insert(
        DatabaseConstants.subjectsTable,
        subject.toMap(),
        // Usar ignore para evitar errores si ya existe (aunque el nombre no es UNIQUE en tu esquema actual)
        // Si el nombre fuera UNIQUE, usar replace o fail sería más apropiado dependiendo del caso de uso.
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    } catch (e) {
      throw DatabaseException('Error al crear materia: ${e.toString()}');
    }
  }

  /// Actualiza una materia existente en la base de datos.
  Future<void> updateSubject(SubjectModel subject) async {
    try {
      final rowsAffected = await db.update(
        DatabaseConstants.subjectsTable,
        subject.toMap(),
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [subject.id],
      );
      if (rowsAffected == 0) {
        throw NotFoundException(
          'Materia no encontrada para actualizar con ID: ${subject.id}',
        );
      }
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException('Error al actualizar materia: ${e.toString()}');
      }
    }
  }

  /// Elimina una materia por su ID.
  Future<void> deleteSubject(int id) async {
    try {
      final rowsAffected = await db.delete(
        DatabaseConstants.subjectsTable,
        where: '${DatabaseConstants.columnId} = ?',
        whereArgs: [id],
      );
      if (rowsAffected == 0) {
        throw NotFoundException(
          'Materia no encontrada para eliminar con ID: $id',
        );
      }
    } catch (e) {
      if (e is NotFoundException) {
        rethrow;
      } else {
        throw DatabaseException('Error al eliminar materia: ${e.toString()}');
      }
    }
  }

  /// Obtiene las materias en las que un estudiante está inscrito.
  Future<List<SubjectModel>> getSubjectsForStudent(int studentId) async {
    try {
      final List<Map<String, dynamic>> assignmentMaps = await db.query(
        DatabaseConstants.assignmentsTable,
        columns: [DatabaseConstants.columnSubjectId],
        where: '${DatabaseConstants.columnStudentId} = ?',
        whereArgs: [studentId],
      );

      if (assignmentMaps.isEmpty) {
        return [];
      }

      final subjectIds =
          assignmentMaps
              .map((map) => map[DatabaseConstants.columnSubjectId] as int)
              .toList();

      final subjectMaps = await db.query(
        DatabaseConstants.subjectsTable,
        where:
            '${DatabaseConstants.columnId} IN (${subjectIds.map((_) => '?').join(',')})',
        whereArgs: subjectIds,
      );
      return List.generate(
        subjectMaps.length,
        (i) => SubjectModel.fromMap(subjectMaps[i]),
      );
    } catch (e) {
      throw DatabaseException(
        'Error al obtener materias del estudiante: ${e.toString()}',
      );
    }
  }
}
