import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../domain/entities/user.dart';
import '../../presentation/providers/auth_provider.dart';
import '../constants/app_constants.dart';
import '../constants/route_constants.dart'; // Para la navegación

class CustomDrawer extends ConsumerWidget {
  final User user;

  const CustomDrawer({super.key, required this.user});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(user.name),
            accountEmail: Text(user.identificationCode),
            currentAccountPicture: CircleAvatar(
              backgroundColor:
                  Theme.of(context).platform == TargetPlatform.iOS
                      ? Colors.blue
                      : Colors.white,
              child: Text(
                user.name.isNotEmpty ? user.name[0].toUpperCase() : 'U',
                style: const TextStyle(fontSize: 40.0),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(FontAwesomeIcons.houseUser),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pop(context); // Cierra el drawer
              // Si HomePage es la ruta raíz después del login, no necesitas navegar.
              // Si tienes una ruta específica para home, úsala:
              // Navigator.pushNamedAndRemoveUntil(context, RouteConstants.home, (route) => false);
            },
          ),

          // Aquí puedes añadir más items de navegación si es necesario
          // Por ejemplo, para la gestión de usuarios o materias si el usuario es profesor
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar Sesión'),
            onTap: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                RouteConstants.login,
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
