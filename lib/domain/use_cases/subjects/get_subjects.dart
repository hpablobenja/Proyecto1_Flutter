import '../../repositories/subjects_repository.dart';
import '../../entities/subject.dart';

class GetSubjects {
  final SubjectsRepository repository;

  GetSubjects(this.repository);

  Future<List<Subject>> call() async {
    return await repository.getSubjects();
  }
}
