import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/subject.dart';
import '../providers.dart'; // Importa el archivo central de providers

final subjectsListProvider = FutureProvider<List<Subject>>((ref) async {
  final getSubjects = ref.read(getSubjectsProvider);
  return await getSubjects();
});
