import '../../repositories/user_repository.dart';
import '../../entities/user.dart';

class GetUsers {
  final UsersRepository repository;

  GetUsers(this.repository);

  Future<List<User>> call() async {
    return await repository.getUsers();
  }
}
