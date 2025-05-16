// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\data\datasources\local\database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../../../core/constants/database_constants.dart';
import '../../../core/constants/app_constants.dart';

class DatabaseHelper {
  static Database? _database;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, DatabaseConstants.databaseName);
    return await openDatabase(
      path,
      version: DatabaseConstants.databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DatabaseConstants.createUsersTable);
    await db.execute(DatabaseConstants.createSubjectsTable);
    await db.execute(DatabaseConstants.createAssignmentsTable);
    await db.execute(DatabaseConstants.createAttendanceTable);
    // Si tienes la tabla de historial de acciones:
    // await db.execute(DatabaseConstants.createHistorialAccionesTable);

    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      var tableInfo = await db.rawQuery(
        'PRAGMA table_info(${DatabaseConstants.attendanceTable})',
      );
      bool columnExists = false;
      for (var column in tableInfo) {
        if (column['name'] == DatabaseConstants.columnIsDeleted) {
          columnExists = true;
          break;
        }
      }

      if (!columnExists) {
        await db.execute('''
          ALTER TABLE ${DatabaseConstants.attendanceTable}
          ADD COLUMN ${DatabaseConstants.columnIsDeleted} INTEGER NOT NULL DEFAULT 0
        ''');
        // ignore: avoid_print
        print(
          "Database upgraded: Added column ${DatabaseConstants.columnIsDeleted} to ${DatabaseConstants.attendanceTable}",
        );
      } else {
        // ignore: avoid_print
        print(
          "Database upgrade: Column ${DatabaseConstants.columnIsDeleted} already exists in ${DatabaseConstants.attendanceTable}.",
        );
      }
    }
    // Futuras migraciones irían aquí con if (oldVersion < X) { ... }
  }

  Future<void> _insertInitialData(Database db) async {
    final teachers = [
      {
        DatabaseConstants.columnIdentificationCode: 'TCH001',
        DatabaseConstants.columnName: 'Roberto Mendez - Matemática',
        DatabaseConstants.columnType: AppConstants.teacherRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'TCH002',
        DatabaseConstants.columnName: 'Maria Torres - Física',
        DatabaseConstants.columnType: AppConstants.teacherRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'TCH003',
        DatabaseConstants.columnName: 'Carlos Ruiz - Química',
        DatabaseConstants.columnType: AppConstants.teacherRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'TCH004',
        DatabaseConstants.columnName: 'Patricia Vega - Historia',
        DatabaseConstants.columnType: AppConstants.teacherRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'TCH005',
        DatabaseConstants.columnName: 'Juan Morales - Lenguaje',
        DatabaseConstants.columnType: AppConstants.teacherRole,
      },
    ];

    for (var teacher in teachers) {
      await db.insert(
        DatabaseConstants.usersTable,
        teacher,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    final subjects = [
      {
        DatabaseConstants.columnSubjectName: 'Matemática',
        DatabaseConstants.columnSchedule: 'Lunes 9:00-11:00',
      },
      {
        DatabaseConstants.columnSubjectName: 'Física',
        DatabaseConstants.columnSchedule: 'Martes 14:00-16:00',
      },
      {
        DatabaseConstants.columnSubjectName: 'Química',
        DatabaseConstants.columnSchedule: 'Miércoles 10:00-12:00',
      },
      {
        DatabaseConstants.columnSubjectName: 'Historia',
        DatabaseConstants.columnSchedule: 'Jueves 14:00-16:00',
      },
      {
        DatabaseConstants.columnSubjectName: 'Lenguaje',
        DatabaseConstants.columnSchedule: 'Viernes 8:00-10:00',
      },
    ];

    for (var subject in subjects) {
      await db.insert(
        DatabaseConstants.subjectsTable,
        subject,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }

    final students = [
      {
        DatabaseConstants.columnIdentificationCode: 'STD001',
        DatabaseConstants.columnName: 'Lucas Martinez - STD001',
        DatabaseConstants.columnType: AppConstants.studentRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'STD002',
        DatabaseConstants.columnName: 'Pedro Suarez - STD002',
        DatabaseConstants.columnType: AppConstants.studentRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'STD003',
        DatabaseConstants.columnName: 'Pablo Juarez - STD003',
        DatabaseConstants.columnType: AppConstants.studentRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'STD004',
        DatabaseConstants.columnName: 'Ana Donoso - STD004',
        DatabaseConstants.columnType: AppConstants.studentRole,
      },
      {
        DatabaseConstants.columnIdentificationCode: 'STD005',
        DatabaseConstants.columnName: 'Gabriela Garcia - STD005',
        DatabaseConstants.columnType: AppConstants.studentRole,
      },
    ];
    List<int> studentIds = [];
    for (var studentData in students) {
      try {
        final id = await db.insert(
          DatabaseConstants.usersTable,
          studentData,
          conflictAlgorithm: ConflictAlgorithm.ignore,
        );
        if (id > 0) {
          studentIds.add(id);
        } else {
          final existingStudent = await db.query(
            DatabaseConstants.usersTable,
            columns: [DatabaseConstants.columnId],
            where: '${DatabaseConstants.columnIdentificationCode} = ?',
            whereArgs: [
              studentData[DatabaseConstants.columnIdentificationCode],
            ],
            limit: 1,
          );
          if (existingStudent.isNotEmpty) {
            studentIds.add(
              existingStudent.first[DatabaseConstants.columnId] as int,
            );
          }
        }
      } catch (e) {
        // ignore: avoid_print
        print(
          "Error insertando estudiante ${studentData[DatabaseConstants.columnName]}: $e",
        );
      }
    }
    List<int> subjectIds = [];
    final subjectMaps = await db.query(
      DatabaseConstants.subjectsTable,
      columns: [DatabaseConstants.columnId],
    );
    for (var map in subjectMaps) {
      subjectIds.add(map[DatabaseConstants.columnId] as int);
    }

    for (int studentId in studentIds) {
      for (int subjectId in subjectIds) {
        try {
          await db.insert(
            DatabaseConstants.assignmentsTable,
            {
              DatabaseConstants.columnStudentId: studentId,
              DatabaseConstants.columnSubjectId: subjectId,
            },
            conflictAlgorithm: ConflictAlgorithm.ignore,
          );
        } catch (e) {
          // ignore: avoid_print
          print(
            "Error asignando materia $subjectId al estudiante $studentId: $e",
          );
        }
      }
    }
  }
}
