import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user.dart';
import '../providers.dart'; // Import the central providers file

final usersListProvider = FutureProvider<List<User>>((ref) async {
  final getUsers = ref.read(getUsersProvider);
  return await getUsers();
});
