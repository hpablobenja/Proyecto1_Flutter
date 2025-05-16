import 'package:flutter/material.dart';
import '../../../domain/entities/user.dart';

class UsersListItem extends StatelessWidget {
  final User user;

  UsersListItem({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(user.name),
        subtitle: Text('Tipo: ${user.type}'),
      ),
    );
  }
}
