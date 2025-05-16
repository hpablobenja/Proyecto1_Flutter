import '../../repositories/user_repository.dart';
import '../../entities/user.dart';

class UpdateUser {
  final UsersRepository repository;

  UpdateUser(this.repository);

  Future<void> call(User user) async {
    await repository.updateUser(user);
  }
}
