import 'package:flutter/material.dart';
import '../../core/config/app_colors.dart';
import 'controllers/recuperar_controller.dart';
import 'widgets/auth_header.dart';
import 'widgets/recuperar_correo.dart';
import 'widgets/recuperar_password.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final controller = RecuperarController();

  bool _codigoEnviado = false;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _solicitarCodigo() async {
    if (controller.cargando) return;

    final error =
        controller.validarCorreo(controller.correo.text);

    if (error != null) {
      _mensaje(error);
      return;
    }

    setState(() => controller.cargando = true);

    try {
      final resultado =
          await controller.solicitarCodigo();

      if (!mounted) return;

      if (resultado['success'] == true) {
        setState(() => _codigoEnviado = true);

        _mensaje(
          resultado['message'] ??
              'Se ha enviado un código a tu correo.',
        );
      } else {
        _mensaje(
          resultado['message'] ??
              'No se pudo enviar el código.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _mensaje(
        'No se pudo enviar el código.',
      );
    } finally {
      if (mounted) {
        setState(() => controller.cargando = false);
      }
    }
  }

  Future<void> _cambiarPassword() async {
    if (controller.cargando) return;

    final codigoError =
        controller.validarCodigo(controller.codigo.text);

    final passwordError =
        controller.validarContrasena(
      controller.nuevaContrasena.text,
    );

    final confirmacionError =
        controller.validarConfirmacion(
      controller.confirmarContrasena.text,
    );

    if (codigoError != null) {
      _mensaje(codigoError);
      return;
    }

    if (passwordError != null) {
      _mensaje(passwordError);
      return;
    }

    if (confirmacionError != null) {
      _mensaje(confirmacionError);
      return;
    }

    setState(() => controller.cargando = true);

    try {
      final resultado =
          await controller.cambiarPassword();

      if (!mounted) return;

      if (resultado['success'] == true) {
        _mensaje(
          resultado['message'] ??
              'Contraseña cambiada exitosamente.',
        );

        await Future.delayed(
          const Duration(milliseconds: 700),
        );

        if (!mounted) return;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (_) => false,
        );
      } else {
        _mensaje(
          resultado['message'] ??
              'No se pudo cambiar la contraseña.',
        );
      }
    } catch (e) {
      if (!mounted) return;

      _mensaje(
        'No se pudo cambiar la contraseña.',
      );
    } finally {
      if (mounted) {
        setState(() => controller.cargando = false);
      }
    }
  }

  void _mensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: AppBar(
        backgroundColor: AppColors.crema,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: AppColors.textoCafe,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              AuthHeader(
                titulo: _codigoEnviado
                    ? 'Nueva contraseña'
                    : 'Recuperar contraseña',
                subtitulo: _codigoEnviado
                    ? 'Ingresa el código y crea una nueva contraseña'
                    : 'Te enviaremos un código a tu correo',
              ),

              const SizedBox(height: 30),

              if (!_codigoEnviado)
                RecuperarCorreo(
                  controller: controller.correo,
                  cargando: controller.cargando,
                  onEnviar: _solicitarCodigo,
                ),

              if (_codigoEnviado)
                RecuperarPassword(
                  codigo: controller.codigo,
                  nuevaContrasena:
                      controller.nuevaContrasena,
                  confirmarContrasena:
                      controller.confirmarContrasena,
                  ocultarContrasena:
                      controller.ocultarContrasena,
                  ocultarConfirmacion:
                      controller.ocultarConfirmacion,
                  cargando: controller.cargando,
                  cambiarContrasena:
                      () => setState(
                    controller.cambiarContrasena,
                  ),
                  cambiarConfirmacion:
                      () => setState(
                    controller.cambiarConfirmacion,
                  ),
                  onCambiar: _cambiarPassword,
                  onReenviar: _solicitarCodigo,
                ),
            ],
          ),
        ),
      ),
    );
  }
}