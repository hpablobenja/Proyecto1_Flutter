import '../entities/subject.dart';

abstract class SubjectsRepository {
  Future<void> addSubject(Subject subject);
  Future<List<Subject>> getSubjects();
  Future<void> deleteSubject(int subjectId); // Add this line
  Future<void> updateSubject(Subject subject); // Añadir esta línea
  Future<List<Subject>> getSubjectsForStudent(int studentId);
}
