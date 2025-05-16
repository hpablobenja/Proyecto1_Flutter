import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart'; // Needed for Database type
// Data Sources
import '../../data/datasources/local/database_helper.dart'; // No se usa directamente aquí, pero es bueno tenerlo si se necesitara
import '../../data/datasources/local/user_local_datasource.dart';
import '../../data/datasources/local/subjects_local_datasource.dart';
import '../../data/datasources/local/attendance_datasource.dart';

// Repositories
import '../../domain/repositories/user_repository.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../../data/repositories/subjects_repository_impl.dart';
import '../../domain/repositories/attendance_repository.dart';
import '../../data/repositories/attendance_repository_impl.dart';

// Use Cases (Auth)
import '../../domain/use_cases/auth/login.dart';

// Use Cases (User)
import '../../domain/use_cases/user/get_users.dart';
import '../../domain/use_cases/user/add_user.dart';
import '../../domain/use_cases/user/update_user.dart';
import '../../domain/use_cases/user/delete_user.dart';

// Use Cases (Subject)
import '../../domain/use_cases/subjects/get_subjects.dart';
import '../../domain/use_cases/subjects/add_subject.dart';
import '../../domain/use_cases/subjects/update_subject.dart';
import '../../domain/use_cases/subjects/delete_subject.dart';
import '../../domain/use_cases/subjects/get_subjects_for_student.dart';
// import '../../domain/use_cases/subjects/get_subjects_for_student.dart'; // Duplicado, se puede quitar

// Use Cases (Attendance)
import '../../domain/use_cases/attendance/get_attendance_records.dart';
import '../../domain/use_cases/attendance/register_attendance.dart';
import '../../domain/use_cases/attendance/delete_attendance_record.dart';

// Entities (Needed for List Providers)
import '../../domain/entities/user.dart';
import '../../domain/entities/subject.dart';
import '../../domain/entities/attendance_record.dart';
import '../../core/constants/app_constants.dart';

// State Providers (Lists, Forms, Filters)
import 'users/user_form_provider.dart';
import 'subjects/subject_form_provider.dart';
import 'attendance/attendance_filter_provider.dart';
import 'auth_provider.dart';
import 'attendance/filtered_attendance_records_provider.dart';
import '../view_models/attendance_record_view_model.dart';

// Re-exporting providers from other files
export 'historial_notifier.dart';
export 'attendance/attendance_filter_provider.dart'
    show
        attendanceFilterProvider,
        AttendanceFilterState,
        AttendanceFilterNotifier,
        AttendanceRecordTypeFilter; // Asegúrate de exportar esto si lo usas en la UI
export 'attendance/filtered_attendance_records_provider.dart'
    show filteredAttendanceRecordsProvider, AttendanceFilterParameters;
export 'attendance/attendance_state_provider.dart'
    show attendanceStateProvider, AttendanceState, AttendanceStateNotifier;
export 'users/user_form_provider.dart' show userFormProvider, UserFormNotifier;
export 'subjects/subject_form_provider.dart'
    show subjectFormProvider, SubjectFormNotifier;

// =============================================================================
// DATABASE PROVIDER
final databaseProvider = Provider<Database>((ref) {
  throw UnimplementedError(
    'databaseProvider no fue sobreescrito. Asegúrate de hacerlo en ProviderScope.',
  );
});

// Provider para el historial de acciones (no el historial de asistencia)
final historialDataProvider = FutureProvider<List<Map<String, dynamic>>>((
  ref,
) async {
  final db = ref.watch(databaseProvider);
  // ignore: avoid_print
  print('historialDataProvider: Re-fetching historial_acciones...');
  final List<Map<String, dynamic>> data = await db.query(
    'historial_acciones', // Asegúrate que esta tabla exista y sea la correcta
    orderBy: 'id DESC',
  );
  return data;
});

// =============================================================================
// DATA SOURCE PROVIDERS

final usersLocalDataSourceProvider = Provider<UsersLocalDataSource>((ref) {
  final db = ref.read(databaseProvider);
  return UsersLocalDataSource(db);
});

final subjectsLocalDataSourceProvider = Provider<SubjectsLocalDataSource>((
  ref,
) {
  final db = ref.read(databaseProvider);
  return SubjectsLocalDataSource(db);
});

final attendanceLocalDataSourceProvider = Provider<AttendanceLocalDataSource>((
  ref,
) {
  final db = ref.read(databaseProvider);
  return AttendanceLocalDataSource(db);
});

// =============================================================================
// REPOSITORY PROVIDERS

final userRepositoryProvider = Provider<UsersRepository>((ref) {
  final localDataSource = ref.read(usersLocalDataSourceProvider);
  return UsersRepositoryImpl(localDataSource);
});

final subjectsRepositoryProvider = Provider<SubjectsRepository>((ref) {
  final localDataSource = ref.read(subjectsLocalDataSourceProvider);
  return SubjectsRepositoryImpl(localDataSource);
});

final attendanceRepositoryProvider = Provider<AttendanceRepository>((ref) {
  final localDataSource = ref.read(attendanceLocalDataSourceProvider);
  return AttendanceRepositoryImpl(localDataSource);
});

// =============================================================================
// USE CASE PROVIDERS

// Auth
final loginUseCaseProvider = Provider<Login>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return Login(repository);
});

// User
final getUsersProvider = Provider<GetUsers>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return GetUsers(repository);
});

final addUserProvider = Provider<AddUser>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return AddUser(repository);
});

final updateUserProvider = Provider<UpdateUser>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return UpdateUser(repository);
});

final deleteUserProvider = Provider<DeleteUser>((ref) {
  final repository = ref.read(userRepositoryProvider);
  return DeleteUser(repository);
});

// Subject
final getSubjectsProvider = Provider<GetSubjects>((ref) {
  final repository = ref.read(subjectsRepositoryProvider);
  return GetSubjects(repository);
});

final addSubjectProvider = Provider<AddSubject>((ref) {
  final repository = ref.read(subjectsRepositoryProvider);
  return AddSubject(repository);
});

final updateSubjectProvider = Provider<UpdateSubject>((ref) {
  final repository = ref.read(subjectsRepositoryProvider);
  return UpdateSubject(repository);
});

final deleteSubjectProvider = Provider<DeleteSubject>((ref) {
  final repository = ref.read(subjectsRepositoryProvider);
  return DeleteSubject(repository);
});

final getSubjectsForStudentUseCaseProvider = Provider<GetSubjectsForStudent>((
  ref,
) {
  final repository = ref.read(subjectsRepositoryProvider);
  return GetSubjectsForStudent(repository);
});

// Attendance
final getAttendanceRecordsProvider = Provider<GetAttendanceRecords>((ref) {
  final repository = ref.read(attendanceRepositoryProvider);
  return GetAttendanceRecords(repository);
});

final registerAttendanceProvider = Provider<RegisterAttendance>((ref) {
  final repository = ref.read(attendanceRepositoryProvider);
  return RegisterAttendance(repository);
});

final deleteAttendanceRecordProvider = Provider<DeleteAttendanceRecord>((ref) {
  final repository = ref.read(attendanceRepositoryProvider);
  return DeleteAttendanceRecord(repository);
});

// =============================================================================
// STATE PROVIDERS (Lists, Forms, Filters)

// User List Provider
final usersListProvider = FutureProvider<List<User>>((ref) async {
  // ignore: avoid_print
  print('usersListProvider: Re-fetching users...');
  final getUsers = ref.read(getUsersProvider);
  return await getUsers();
});

// Subject List Provider
final subjectsListProvider = FutureProvider<List<Subject>>((ref) async {
  // ignore: avoid_print
  print('subjectsListProvider: Re-fetching subjects...');
  final getSubjects = ref.read(getSubjectsProvider);
  return await getSubjects();
});

// Attendance List Provider
final attendanceListProvider = FutureProvider<List<AttendanceRecord>>((
  ref,
) async {
  // ignore: avoid_print
  print('attendanceListProvider: Re-fetching attendance records...');
  final getAttendanceRecords = ref.read(getAttendanceRecordsProvider);
  return await getAttendanceRecords();
});

// Provider for student's enrolled subjects
final studentEnrolledSubjectsProvider = FutureProvider<List<Subject>>((
  ref,
) async {
  final authState = ref.watch(authProvider);
  final student = authState.user;
  if (student == null || student.type != AppConstants.studentRole) {
    // ignore: avoid_print
    print(
      'studentEnrolledSubjectsProvider: No student logged in or not a student role.',
    );
    return [];
  }
  // ignore: avoid_print
  print(
    'studentEnrolledSubjectsProvider: Fetching subjects for student ID ${student.id}',
  );
  final getSubjectsForStudent = ref.read(getSubjectsForStudentUseCaseProvider);
  return getSubjectsForStudent.call(student.id);
});
