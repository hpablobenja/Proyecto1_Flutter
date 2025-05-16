import '../datasources/local/user_local_datasource.dart'; // Import the local datasource
import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/models/user_model.dart'; // Corregir la ruta de importación

class UsersRepositoryImpl implements UsersRepository {
  final UsersLocalDataSource localDataSource; // Inject UsersLocalDataSource

  UsersRepositoryImpl(this.localDataSource);

  @override
  Future<void> addUser(User user) async {
    // Convert User entity to UserModel
    final userModel = UserModel(
      id: user.id, // Assuming id might be null for new users if auto-generated
      identificationCode: user.identificationCode,
      name: user.name,
      type: user.type,
      qrCode: user.assignedQrCode,
    );
    await localDataSource.createUser(userModel);
  }

  @override
  Future<List<User>> getUsers() async {
    final userModels = await localDataSource.getUsers();
    // Convert List<UserModel> to List<User>
    return userModels
        .map(
          (model) => User(
            id: model.id,
            identificationCode: model.identificationCode,
            name: model.name,
            type: model.type,
            assignedQrCode: model.qrCode,
          ),
        )
        .toList();
  }

  @override
  Future<void> deleteUser(int userId) async {
    await localDataSource.deleteUser(userId);
  }

  @override
  Future<void> updateUser(User user) async {
    // Convert User entity to UserModel
    final userModel = UserModel(
      id: user.id, // ID is crucial for updating the correct record
      identificationCode: user.identificationCode,
      name: user.name,
      type: user.type,
      qrCode: user.assignedQrCode,
    );
    await localDataSource.updateUser(userModel);
  }

  @override
  Future<User> login(String identificationCode, String password) async {
    // Delegar la lógica de login al datasource local.
    // El datasource debería encargarse de consultar la base de datos
    // y verificar la contraseña.
    try {
      // Asumiendo que UsersLocalDataSource tiene un método como `getUserByIdentificationCodeAndPassword`
      // o una combinación de `getUserByIdentificationCode` y luego una verificación de contraseña.
      // Por ahora, vamos a simular que existe un método que devuelve el UserModel si las credenciales son correctas.
      // Necesitarás implementar la lógica real en UsersLocalDataSource.
      final userModel = await localDataSource
          .getUserByIdentificationCodeAndPassword(identificationCode, password);
      // Convertir UserModel a User entidad antes de retornar
      return User(
        id: userModel.id,
        identificationCode: userModel.identificationCode,
        name: userModel.name,
        type: userModel.type,
        assignedQrCode: userModel.qrCode,
      );
    } catch (e) {
      // Re-lanzar o envolver excepciones desde el datasource (ej. NotFoundException, AuthenticationException)
      rethrow; // Dejar que el caso de uso maneje excepciones específicas
    }
  }
}
