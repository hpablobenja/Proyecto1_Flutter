import '../../repositories/user_repository.dart';

class DeleteUser {
  final UsersRepository repository;

  DeleteUser(this.repository);

  Future<void> call(int userId) async {
    await repository.deleteUser(userId);
  }
}
