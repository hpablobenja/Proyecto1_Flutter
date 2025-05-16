import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandlerWidget extends StatefulWidget {
  final Permission permission;
  final Widget child;
  final String deniedMessage;
  final String permanentlyDeniedMessage;

  const PermissionHandlerWidget({
    super.key,
    required this.permission,
    required this.child,
    this.deniedMessage = 'Se necesita permiso para acceder a esta función',
    this.permanentlyDeniedMessage =
        'El permiso fue denegado permanentemente. Por favor habilítalo en la configuración',
  });

  @override
  State<PermissionHandlerWidget> createState() =>
      _PermissionHandlerWidgetState();
}

class _PermissionHandlerWidgetState extends State<PermissionHandlerWidget> {
  PermissionStatus _permissionStatus = PermissionStatus.denied;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await widget.permission.status;
    setState(() => _permissionStatus = status);
  }

  Future<void> _requestPermission() async {
    final status = await widget.permission.request();
    setState(() => _permissionStatus = status);
  }

  @override
  Widget build(BuildContext context) {
    switch (_permissionStatus) {
      case PermissionStatus.granted:
      case PermissionStatus.limited:
        return widget.child;
      case PermissionStatus.denied:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.deniedMessage),
              TextButton(
                onPressed: _requestPermission,
                child: const Text('Solicitar permiso'),
              ),
            ],
          ),
        );
      case PermissionStatus.permanentlyDenied:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.permanentlyDeniedMessage),
              TextButton(
                onPressed: () => openAppSettings(),
                child: const Text('Abrir configuración'),
              ),
            ],
          ),
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }
}
