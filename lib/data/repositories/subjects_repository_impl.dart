import '../datasources/local/subjects_local_datasource.dart';
import '../../domain/entities/subject.dart';
import '../../domain/repositories/subjects_repository.dart';
import '../models/subject_model.dart'; // Import SubjectModel

class SubjectsRepositoryImpl implements SubjectsRepository {
  final SubjectsLocalDataSource localDataSource;

  SubjectsRepositoryImpl(this.localDataSource);

  @override
  Future<void> addSubject(Subject subject) async {
    // Convert Subject entity to SubjectModel
    final subjectModel = SubjectModel(
      id:
          subject
              .id, // Assuming id can be passed for creation if it's an update, or null for new
      name: subject.name,
      schedule: subject.schedule,
    );
    await localDataSource.createSubject(subjectModel);
  }

  @override
  Future<List<Subject>> getSubjects() async {
    final subjectModels = await localDataSource.getSubjects();
    // Convert SubjectModel list to Subject entity list
    return subjectModels
        .map(
          (model) => Subject(
            id: model.id!, // Assuming id is not null when fetched
            name: model.name,
            schedule: model.schedule,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteSubject(int subjectId) async {
    await localDataSource.deleteSubject(subjectId);
  }

  @override
  Future<void> updateSubject(Subject subject) async {
    // Convert Subject entity to SubjectModel
    final subjectModel = SubjectModel(
      id: subject.id, // El ID es necesario para la actualización
      name: subject.name,
      schedule: subject.schedule,
    );
    await localDataSource.updateSubject(subjectModel);
  }

  @override
  Future<List<Subject>> getSubjectsForStudent(int studentId) async {
    final subjectModels = await localDataSource.getSubjectsForStudent(
      studentId,
    );
    return subjectModels
        .map(
          (model) => Subject(
            id: model.id!,
            name: model.name,
            schedule: model.schedule,
          ),
        )
        .toList();
  }
}
