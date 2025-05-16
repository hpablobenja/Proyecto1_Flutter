import '../../entities/user.dart';
import '../../repositories/user_repository.dart'; // Ensure this path is correct

class Login {
  final UsersRepository repository;

  Login(this.repository);

  Future<User> call(LoginParams params) async {
    // Here you would typically call a login method on your repository
    // For now, assuming your repository has a method like `login(identificationCode, password)`
    return await repository.login(params.identificationCode, params.password);
  }
}

class LoginParams {
  final String identificationCode;
  final String password;

  LoginParams({required this.identificationCode, required this.password});
}
