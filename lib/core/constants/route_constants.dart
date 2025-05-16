import 'package:flutter/material.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/home_page.dart';

class RouteConstants {
  // Rutas principales
  static const String login = '/login';
  static const String home = '/home';

  // Sub-rutas
  static const String qrScanner = 'qr-scanner';
  static const String attendanceHistory = 'attendance-history';
  static const String usersManagement = 'users-management';
  static const String subjectsManagement = 'subjects-management';

  // Rutas completas
  static const String fullQrScanner = '$home/$qrScanner';
  static const String fullAttendanceHistory = '$home/$attendanceHistory';
  static const String fullUsersManagement = '$home/$usersManagement';
  static const String fullSubjectsManagement = '$home/$subjectsManagement';

  // Rutas de detalles
  static const String userDetail = 'user-detail';
  static const String subjectDetail = 'subject-detail';

  // Parámetros de rutas
  static const String userIdParam = 'userId';
  static const String subjectIdParam = 'subjectId';

  // Helpers para construir rutas
  static String buildUserDetailPath(int userId) =>
      '$fullUsersManagement/$userDetail?$userIdParam=$userId';
  static String buildSubjectDetailPath(int subjectId) =>
      '$fullSubjectsManagement/$subjectDetail?$subjectIdParam=$subjectId';

  // Extraer parámetros
  static int? getUserIdFromParams(Map<String, String> params) {
    final id = params[userIdParam];
    return id != null ? int.tryParse(id) : null;
  }

  static int? getSubjectIdFromParams(Map<String, String> params) {
    final id = params[subjectIdParam];
    return id != null ? int.tryParse(id) : null;
  }

  // Mapa de rutas para MaterialApp
  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const LoginPage(),
      home: (context) => const HomePage(),
      // Aquí puedes añadir más rutas principales si las tienes
    };
  }
}
