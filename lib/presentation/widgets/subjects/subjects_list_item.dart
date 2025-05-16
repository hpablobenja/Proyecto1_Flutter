import 'package:flutter/material.dart';
import '../../../domain/entities/subject.dart';

class SubjectsListItem extends StatelessWidget {
  final Subject subject;

  SubjectsListItem({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(subject.name),
        subtitle: Text('Horario: ${subject.schedule}'),
      ),
    );
  }
}
