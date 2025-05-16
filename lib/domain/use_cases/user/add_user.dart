import '../../repositories/user_repository.dart';
import '../../entities/user.dart';

class AddUser {
  final UsersRepository repository;

  AddUser(this.repository);

  Future<void> call(User user) async {
    await repository.addUser(user);
  }
}
