import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';

class UserFormNotifier extends StateNotifier<User?> {
  UserFormNotifier() : super(null);

  void setUser(User user) {
    state = user;
  }

  void clear() {
    state = null;
  }
}

final userFormProvider = StateNotifierProvider<UserFormNotifier, User?>((ref) {
  return UserFormNotifier();
});
