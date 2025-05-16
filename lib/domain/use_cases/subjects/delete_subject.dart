import '../../repositories/subjects_repository.dart';

class DeleteSubject {
  final SubjectsRepository repository;

  DeleteSubject(this.repository);

  Future<void> call(int subjectId) async {
    await repository.deleteSubject(subjectId);
  }
}
