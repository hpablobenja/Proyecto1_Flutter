import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasources/local/database_helper.dart';

final databaseProvider = Provider<DatabaseHelper>(
  (ref) => DatabaseHelper.instance,
); // Usar la instancia Singleton
