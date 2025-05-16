import '../../repositories/subjects_repository.dart';
import '../../entities/subject.dart';

class UpdateSubject {
  final SubjectsRepository repository;

  UpdateSubject(this.repository);

  Future<void> call(Subject subject) async {
    await repository.updateSubject(subject);
  }
}
