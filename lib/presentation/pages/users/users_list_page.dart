import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/users/users_list_provider.dart';
import '../../../core/constants/app_constants.dart'; // Importar AppConstants
import '../../../domain/entities/user.dart';

class UsersListPage extends ConsumerWidget {
  const UsersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersList = ref.watch(usersListProvider);

    return DefaultTabController(
      length: 2, // Dos pestañas: Maestros y Estudiantes
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Usuarios'),
          bottom: const TabBar(
            tabs: [Tab(text: 'Maestros'), Tab(text: 'Estudiantes')],
          ),
        ),
        body: usersList.when(
          data: (users) {
            final teachers =
                users
                    .where((user) => user.type == AppConstants.teacherRole)
                    .toList();
            final students =
                users
                    .where((user) => user.type == AppConstants.studentRole)
                    .toList();

            return TabBarView(
              children: [
                _buildUserList(teachers, 'No hay maestros registrados.'),
                _buildUserList(students, 'No hay estudiantes registrados.'),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error:
              (error, _) =>
                  Center(child: Text('Error al cargar usuarios: $error')),
        ),
      ),
    );
  }

  Widget _buildUserList(List<User> users, String emptyListMessage) {
    if (users.isEmpty) {
      return Center(
        child: Text(emptyListMessage, style: const TextStyle(fontSize: 16)),
      );
    }
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: ListTile(
            leading: Icon(
              user.type == AppConstants.teacherRole
                  ? Icons.school
                  : Icons.person,
            ),
            title: Text(user.name),
            subtitle: Text('ID: ${user.identificationCode}'),
          ),
        );
      },
    );
  }
}
