import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/subjects/subject_form_provider.dart';
import '../../../domain/entities/subject.dart';

class SubjectFormWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subject = ref.watch(subjectFormProvider);

    return Column(
      children: [
        TextField(
          decoration: InputDecoration(labelText: 'Nombre de la Materia'),
          onChanged: (value) {
            if (subject != null) {
              ref
                  .read(subjectFormProvider.notifier)
                  .setSubject(
                    Subject(
                      id: subject.id,
                      name: value,
                      schedule: subject.schedule,
                    ),
                  );
            }
          },
        ),
        TextField(
          decoration: InputDecoration(labelText: 'Horario'),
          onChanged: (value) {
            if (subject != null) {
              ref
                  .read(subjectFormProvider.notifier)
                  .setSubject(
                    Subject(
                      id: subject.id,
                      name: subject.name,
                      schedule: value,
                    ),
                  );
            }
          },
        ),
      ],
    );
  }
}
