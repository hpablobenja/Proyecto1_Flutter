import '../../repositories/subjects_repository.dart';
import '../../entities/subject.dart';

class AddSubject {
  final SubjectsRepository repository;

  AddSubject(this.repository);

  Future<void> call(Subject subject) async {
    await repository.addSubject(subject);
  }
}
