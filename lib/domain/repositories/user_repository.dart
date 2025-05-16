import '../entities/user.dart';

abstract class UsersRepository {
  Future<void> addUser(User user);
  Future<List<User>> getUsers();
  Future<void> deleteUser(int userId); // Assuming this method exists
  Future<void> updateUser(User user); // Assuming this method exists
  Future<User> login(
    String identificationCode,
    String password,
  ); // Add this method
}
