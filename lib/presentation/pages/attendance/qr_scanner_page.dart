// c:\Users\BENJAMIN\Documents\Maestria Flutter\proyecto_final\lib\presentation\pages\attendance\qr_scanner_page.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:proyecto_final/presentation/providers/providers.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/widgets/custom_loading_indicator.dart';

class QRScannerPage extends ConsumerStatefulWidget {
  const QRScannerPage({super.key});

  @override
  ConsumerState<QRScannerPage> createState() => _QRScannerPageState();
}

class _QRScannerPageState extends ConsumerState<QRScannerPage> {
  MobileScannerController cameraController = MobileScannerController(
    // Opciones de la cámara si son necesarias
    // detectionSpeed: DetectionSpeed.noDuplicates, // Podría ayudar con detecciones múltiples rápidas
  );
  bool _isProcessing = false;
  String? _feedbackMessage;
  bool _showCooldown = false;
  int _cooldownSeconds = 10;
  Timer? _cooldownTimer;

  @override
  void dispose() {
    cameraController.dispose();
    _cooldownTimer?.cancel();
    super.dispose();
  }

  void _startCooldown() {
    setState(() {
      _showCooldown = true;
      _cooldownSeconds = 10; // Duración del enfriamiento
    });
    _cooldownTimer?.cancel(); // Cancela cualquier timer anterior
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        // Verificar si el widget sigue montado
        timer.cancel();
        return;
      }
      if (_cooldownSeconds > 0) {
        setState(() {
          _cooldownSeconds--;
        });
      } else {
        timer.cancel();
        setState(() {
          _showCooldown = false;
          _isProcessing = false; // Permitir nuevo escaneo después del cooldown
          _feedbackMessage = null; // Limpiar mensaje de feedback
        });
      }
    });
  }

  Future<void> _processQrCode(String qrData) async {
    if (!mounted) return;
    setState(() {
      _isProcessing = true;
      _feedbackMessage = null;
    });

    // ignore: avoid_print
    print('QRScannerPage - _processQrCode - Raw QR Data: "$qrData"');

    final parts = qrData.split(';');
    // ignore: avoid_print
    print(
      'QRScannerPage - _processQrCode - Split Parts: $parts (Length: ${parts.length})',
    );

    if (parts.length == 3) {
      final studentCode = parts[0];
      final subjectName = parts[1];
      final eventType = parts[2];

      try {
        await ref
            .read(registerAttendanceProvider) // Accede al caso de uso
            .call(
              // Llama al método call con parámetros nombrados
              studentCode: studentCode,
              subjectName: subjectName,
              eventType: eventType,
            );
        if (!mounted) return;

        // Invalidar el provider de la lista de asistencias para forzar una actualización
        ref.refresh(attendanceListProvider);
        // Notificar al estado de asistencia que necesita actualizarse
        ref.read(attendanceStateProvider.notifier).markForRefresh();

        setState(() {
          _feedbackMessage =
              'Asistencia registrada para $studentCode en $subjectName ($eventType).';
        });
        _startCooldown();
      } on ConflictException catch (e) {
        if (!mounted) return;
        setState(() {
          _feedbackMessage = e.message;
          _isProcessing = false; // Permitir reintentar si es error de conflicto
        });
      } on NotFoundException catch (e) {
        if (!mounted) return;
        setState(() {
          _feedbackMessage = e.message;
          _isProcessing = false;
        });
      } catch (e) {
        if (!mounted) return;
        setState(() {
          _feedbackMessage = 'Error desconocido: ${e.toString()}';
          _isProcessing = false;
        });
      }
    } else {
      if (!mounted) return;
      setState(() {
        _feedbackMessage = 'Formato de QR inválido.';
        _isProcessing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR de Asistencia'),
        actions: [
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.torchState,
              builder: (context, state, child) {
                switch (state) {
                  case TorchState.off:
                    return const Icon(Icons.flash_off, color: Colors.grey);
                  case TorchState.on:
                    return const Icon(Icons.flash_on, color: Colors.yellow);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.toggleTorch(),
          ),
          IconButton(
            icon: ValueListenableBuilder(
              valueListenable: cameraController.cameraFacingState,
              builder: (context, state, child) {
                switch (state) {
                  case CameraFacing.front:
                    return const Icon(Icons.camera_front);
                  case CameraFacing.back:
                    return const Icon(Icons.camera_rear);
                }
              },
            ),
            iconSize: 32.0,
            onPressed: () => cameraController.switchCamera(),
          ),
        ],
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          MobileScanner(
            controller: cameraController,
            onDetect: (capture) {
              if (_isProcessing || _showCooldown) return;

              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty && barcodes.first.rawValue != null) {
                final String qrData = barcodes.first.rawValue!;
                // ignore: avoid_print
                print('QR Detectado: $qrData');
                _processQrCode(qrData);
              }
            },
          ),
          // Widget para el overlay del contador
          if (_showCooldown)
            Container(
              color: Colors.black.withOpacity(0.75),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Siguiente escaneo en:',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '$_cooldownSeconds',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (_feedbackMessage != null &&
                        _feedbackMessage!.contains('registrada'))
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Chip(
                          avatar: const Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          label: Text(_feedbackMessage!),
                          backgroundColor: Colors.green.shade700,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          // Mostrar mensaje de feedback (errores o info) cuando no está en cooldown
          if (_feedbackMessage != null && !_showCooldown)
            Positioned(
              bottom: MediaQuery.of(context).size.height * 0.15,
              left: 20,
              right: 20,
              child: Material(
                // Envolver Chip en Material para sombras y bordes si se desea
                elevation: 4.0,
                borderRadius: BorderRadius.circular(20.0),
                child: Chip(
                  padding: const EdgeInsets.all(12.0),
                  label: Text(_feedbackMessage!, textAlign: TextAlign.center),
                  backgroundColor:
                      _feedbackMessage!.startsWith('Error') ||
                              _feedbackMessage!.startsWith('Formato') ||
                              _feedbackMessage!.contains('no encontrado') ||
                              _feedbackMessage!.contains('ya fue registrada')
                          ? Colors.redAccent.shade200
                          : Colors
                              .orangeAccent
                              .shade200, // Para otros mensajes informativos
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          // Indicador de carga mientras se procesa y no está en cooldown
          if (_isProcessing && !_showCooldown) const CustomLoadingIndicator(),
        ],
      ),
    );
  }
}
