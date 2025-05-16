import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/qr_utils.dart';
// import '../../../core/widgets/custom_app_bar.dart'; // No es necesario si es una pestaña
import '../../../core/widgets/custom_error_widget.dart';
import '../../../core/widgets/custom_loading_indicator.dart';
import '../../../domain/entities/subject.dart';
import '../../../domain/entities/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/providers.dart'; // Para studentEnrolledSubjectsProvider

class GenerateQRPage extends ConsumerStatefulWidget {
  const GenerateQRPage({super.key});

  @override
  ConsumerState<GenerateQRPage> createState() => _GenerateQRPageState();
}

class _GenerateQRPageState extends ConsumerState<GenerateQRPage> {
  Subject? _selectedSubject;
  String _selectedEventType = 'entry'; // Valor por defecto: entrada

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final User? currentUser = authState.user;

    if (currentUser == null || currentUser.type != AppConstants.studentRole) {
      return const Scaffold(
        body: Center(child: Text('Acceso no autorizado para esta función.')),
      );
    }

    final enrolledSubjectsAsync = ref.watch(studentEnrolledSubjectsProvider);

    return Scaffold(
      // No necesitamos AppBar aquí si es una pestaña dentro de HomePage
      // appBar: const CustomAppBar(title: 'Generar Código QR', showLogout: false),
      body: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Selecciona una materia y tipo de evento para generar tu código QR:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            enrolledSubjectsAsync.when(
              data: (subjects) {
                if (subjects.isEmpty) {
                  return const Text(
                    'No estás inscrito en ninguna materia actualmente.',
                  );
                }
                // Si _selectedSubject es nulo pero hay materias, y no es la primera construcción,
                // podríamos preseleccionar la primera materia.
                // Opcionalmente, si _selectedSubject ya no está en la lista de 'subjects' (poco probable aquí),
                // se podría resetear.
                if (_selectedSubject != null &&
                    !subjects.contains(_selectedSubject)) {
                  // Esto podría pasar si la lista de materias cambia dinámicamente y la seleccionada ya no existe.
                  // En ese caso, reseteamos _selectedSubject.
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) {
                      // Asegurarse que el widget está montado antes de llamar a setState
                      setState(() {
                        _selectedSubject = null;
                      });
                    }
                  });
                }

                return Column(
                  children: [
                    DropdownButtonFormField<Subject>(
                      decoration: const InputDecoration(
                        labelText: 'Materia',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedSubject,
                      hint: const Text('Selecciona una materia'),
                      items:
                          subjects.map((Subject subject) {
                            return DropdownMenuItem<Subject>(
                              value: subject,
                              child: Text(subject.name),
                            );
                          }).toList(),
                      onChanged: (Subject? newValue) {
                        setState(() {
                          _selectedSubject = newValue;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Tipo de Evento',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedEventType,
                      items: const [
                        DropdownMenuItem(
                          value: 'entry',
                          child: Text('Entrada'),
                        ),
                        DropdownMenuItem(value: 'exit', child: Text('Salida')),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedEventType = newValue;
                          });
                        }
                      },
                    ),
                  ],
                );
              },
              loading:
                  () => const CustomLoadingIndicator(
                    message: 'Cargando tus materias...',
                  ),
              error:
                  (error, stack) => CustomErrorWidget(
                    message: 'Error al cargar materias: ${error.toString()}',
                  ),
            ),
            const SizedBox(height: 30),
            if (_selectedSubject != null &&
                currentUser.identificationCode.isNotEmpty)
              Center(
                child: Column(
                  children: [
                    Text(
                      'QR para: ${currentUser.name}\nMateria: ${_selectedSubject!.name}\nEvento: ${_selectedEventType == 'entry' ? 'Entrada' : 'Salida'}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 15),
                    QrImageView(
                      data: QRUtils.generateQRCode(
                        currentUser.identificationCode,
                        _selectedSubject!.name,
                        eventType: _selectedEventType,
                      ),
                      version: QrVersions.auto,
                      size: 200.0,
                      gapless:
                          false, // Para evitar problemas de escaneo con algunos lectores
                      // Puedes añadir un logo en el centro si quieres:
                      // embeddedImage: AssetImage('assets/images/logo.png'),
                      // embeddedImageStyle: QrEmbeddedImageStyle(
                      //   size: Size(40, 40),
                      // ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
