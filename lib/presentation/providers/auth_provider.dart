import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/user.dart';
import '../../domain/use_cases/auth/login.dart'; // Asegúrate que esta ruta sea correcta
import '../../core/errors/exceptions.dart'; // Para manejar excepciones personalizadas
import 'providers.dart'; // Asumiendo que aquí defines loginUseCaseProvider

// El provider para el caso de uso de login, si no está ya en providers.dart
// final loginUseCaseProvider = Provider<Login>((ref) {
//   final userRepository = ref.watch(usersRepositoryProvider); // Asumiendo que tienes un usersRepositoryProvider
//   return Login(userRepository);
// });

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // Inyectar el caso de uso de login
  final loginUseCase = ref.watch(loginUseCaseProvider);
  return AuthNotifier(loginUseCase);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final Login _loginUseCase;

  AuthNotifier(this._loginUseCase) : super(AuthState.initial());

  Future<void> login(String identificationCode, String password) async {
    state = AuthState.loading();
    try {
      // Aquí llamarías a tu caso de uso de login
      // El caso de uso debería devolver la entidad User
      final user = await _loginUseCase.call(
        LoginParams(identificationCode: identificationCode, password: password),
      );
      state = AuthState.authenticated(user);
    } on AuthenticationException catch (e) {
      state = AuthState.error(e.message);
    } on NotFoundException catch (_) {
      // Captura NotFoundException específicamente
      state = AuthState.error(
        'Usuario no encontrado o credenciales inválidas.',
      );
    } catch (e) {
      // Es útil imprimir el error real en la consola para depuración
      print('Error de login no esperado: $e');
      state = AuthState.error('Ocurrió un error inesperado durante el login.');
    }
  }

  void logout() {
    state = AuthState.initial();
  }

  // Nuevo método para limpiar el mensaje de error
  void clearErrorMessage() {
    // Solo actualiza el estado si actualmente hay un mensaje de error.
    if (state.errorMessage != null) {
      state = state.copyWith(clearErrorMessage: true);
    }
  }

  // Podrías implementar checkSession para verificar si hay una sesión activa
  // (ej. leyendo de SharedPreferences o SecureStorage)
  Future<void> checkSession() async {
    // Lógica para verificar sesión...
    // Por ahora, lo dejamos como estaba en tu LoginPage
    // Si encuentras un usuario, actualiza el estado:
    // state = AuthState.authenticated(userFromSession);
  }
}

class AuthState {
  final bool isAuthenticated;
  final User? user;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    required this.isAuthenticated,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  factory AuthState.initial() {
    return const AuthState(isAuthenticated: false);
  }

  AuthState copyWith({
    bool? isAuthenticated,
    User? user, // Cambiado de userType a user
    bool? isLoading,
    String? errorMessage,
    // Si quieres una forma de limpiar el error o el usuario específicamente
    bool clearUser = false,
    bool clearErrorMessage = false,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      user: clearUser ? null : user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage:
          clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    );
  }

  factory AuthState.loading() {
    return const AuthState(
      isAuthenticated: false,
      isLoading: true,
      errorMessage: null,
    );
  }

  factory AuthState.authenticated(User user) {
    return AuthState(isAuthenticated: true, user: user);
  }

  factory AuthState.error(String message) {
    return AuthState(isAuthenticated: false, errorMessage: message);
  }

  String? get userType => user?.type;
}
