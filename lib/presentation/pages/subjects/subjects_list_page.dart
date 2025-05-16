import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects/subjects_list_provider.dart';

class SubjectsListPage extends ConsumerWidget {
  const SubjectsListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subjectsList = ref.watch(subjectsListProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Materias')),
      body: subjectsList.when(
        data:
            (subjects) => ListView.builder(
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subject = subjects[index];
                return ListTile(
                  title: Text(subject.name),
                  subtitle: Text('Horario: ${subject.schedule}'),
                );
              },
            ),
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text('Error al cargar materias')),
      ),
    );
  }
}
