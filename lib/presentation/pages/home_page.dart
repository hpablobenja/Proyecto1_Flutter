import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/user.dart';
import '../providers/auth_provider.dart';
import '../pages/auth/login_page.dart'; // Importar LoginPage
import '../../../core/widgets/custom_app_bar.dart';
import '../../../core/widgets/custom_drawer.dart';
import '../../../core/constants/app_constants.dart'; // Importar AppConstants
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import 'attendance/qr_scanner_page.dart';
import 'attendance/attendance_history_page.dart';
import 'users/users_list_page.dart';
import 'student/generate_qr_page.dart'; // Importar la nueva página

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    if (authState.isLoading) {
      return const Scaffold(body: CustomLoadingIndicator());
    }

    if (authState.errorMessage != null) {
      return Scaffold(
        body: CustomErrorWidget(message: authState.errorMessage!),
      );
    }

    return authState.user == null
        ? const LoginPage()
        : _buildHomePage(context, authState.user!);
  }

  Widget _buildHomePage(BuildContext context, User user) {
    return DefaultTabController(
      length:
          user.type == AppConstants.teacherRole
              ? 3
              : 2, // Longitud de pestañas para estudiante es 2

      child: Scaffold(
        appBar: CustomAppBar(
          title: 'Bienvenido, ${user.name}',
          bottom:
              user.type ==
                      AppConstants
                          .teacherRole // Usar AppConstants
                  ? const TabBar(
                    tabs: [
                      Tab(
                        icon: Icon(FontAwesomeIcons.qrcode),
                        text: 'Escanear',
                      ),
                      Tab(icon: Icon(Icons.history), text: 'Asistencias'),
                      Tab(icon: Icon(Icons.people), text: 'Usuarios'),
                    ],
                  )
                  : const TabBar(
                    isScrollable:
                        false, // Puede ser true si tienes muchas pestañas
                    tabs: [
                      Tab(icon: Icon(Icons.history), text: 'Mis Asistencias'),
                      // Tab(icon: Icon(Icons.book), text: 'Mis Materias'), // Puedes crear una página para esto
                      Tab(
                        icon: Icon(FontAwesomeIcons.qrcode),
                        text: 'Generar QR',
                      ),
                    ],
                  ),
        ),
        drawer: CustomDrawer(user: user),
        body:
            user.type ==
                    AppConstants
                        .teacherRole // Usar AppConstants
                ? const TabBarView(
                  children: [
                    QRScannerPage(),
                    AttendanceHistoryPage(),
                    UsersListPage(),
                  ],
                )
                : TabBarView(
                  // Para estudiantes
                  children: [
                    const AttendanceHistoryPage(),
                    const GenerateQRPage(), // Nueva página para generar QR
                  ],
                ),
      ),
    );
  }
}

// Widget de ítem para el drawer
