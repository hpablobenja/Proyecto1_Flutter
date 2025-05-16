import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'core/constants/route_constants.dart';
import 'data/datasources/local/database_helper.dart'; // Importar DatabaseHelper
import 'presentation/pages/auth/login_page.dart'; // Importar LoginPage
import 'presentation/providers/providers.dart'; // Importar el archivo central de providers

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar base de datos
  final database = await initializeDatabase();

  runApp(
    ProviderScope(
      overrides: [databaseProvider.overrideWithValue(database)],
      child: const MyApp(),
    ),
  );
}

Future<Database> initializeDatabase() async {
  // Se asume que DatabaseHelper().database (el getter en la clase DatabaseHelper)
  // se encarga de obtener la ruta correcta usando getApplicationDocumentsDirectory()
  // y DatabaseHelper.dbName, y luego abre o crea la base de datos.
  return DatabaseHelper
      .instance // Usar la instancia Singleton
      .database; // Llama al getter 'database' de una instancia de DatabaseHelper.
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Colegio Nikola Tesla',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const LoginPage(),
      routes:
          RouteConstants
              .routes, // Usar RouteConstants y asumir un campo estático 'routes'
      debugShowCheckedModeBanner: false,
    );
  }
}
