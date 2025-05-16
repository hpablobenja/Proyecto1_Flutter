import 'package:flutter/material.dart';
import '../../../domain/entities/subject.dart';

class SubjectDetailPage extends StatelessWidget {
  final Subject subject;

  SubjectDetailPage({required this.subject});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subject.name)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Horario: ${subject.schedule}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
