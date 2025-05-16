import '../../entities/subject.dart';
import '../../repositories/subjects_repository.dart';

class GetSubjectsForStudent {
  final SubjectsRepository repository;

  GetSubjectsForStudent(this.repository);

  Future<List<Subject>> call(int studentId) async {
    return repository.getSubjectsForStudent(studentId);
  }
}
