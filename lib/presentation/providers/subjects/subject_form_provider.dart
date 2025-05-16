import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/subject.dart';

class SubjectFormNotifier extends StateNotifier<Subject?> {
  SubjectFormNotifier() : super(null);

  void setSubject(Subject subject) {
    state = subject;
  }

  void clear() {
    state = null;
  }
}

final subjectFormProvider =
    StateNotifierProvider<SubjectFormNotifier, Subject?>((ref) {
      return SubjectFormNotifier();
    });
