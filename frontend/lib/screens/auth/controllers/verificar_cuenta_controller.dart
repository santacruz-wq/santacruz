import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';

class VerificarCuentaController {
  final codigo = TextEditingController();

  bool cargando = false;
  bool reenviando = false;

  void dispose() {
    codigo.dispose();
  }

  Future<bool> verificarCuenta(
    BuildContext context,
    String email,
  ) async {
    if (cargando) return false;

    final codigoIngresado = codigo.text.trim();

    if (codigoIngresado.isEmpty) {
      mostrarMensaje(
        context,
        'Ingresa el código de verificación.',
      );
      return false;
    }

    if (codigoIngresado.length != 6) {
      mostrarMensaje(
        context,
        'El código debe tener 6 dígitos.',
      );
      return false;
    }

    cargando = true;

    try {
      final resultado = await AuthService.verificarCuenta(
        email,
        codigoIngresado,
      );

      if (!context.mounted) return false;

      if (resultado['success'] == true) {
        mostrarMensaje(
          context,
          resultado['message'] ??
              'Cuenta verificada correctamente.',
        );

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!context.mounted) return false;

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/login',
          (route) => false,
        );

        return true;
      }

      mostrarMensaje(
        context,
        resultado['message'] ??
            'El código no es válido.',
      );

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      mostrarMensaje(
        context,
        'No se pudo verificar la cuenta. Intenta nuevamente.',
      );

      return false;
    } finally {
      cargando = false;
    }
  }

  Future<void> reenviarCodigo(
    BuildContext context,
    String email,
  ) async {
    if (reenviando) return;

    reenviando = true;

    try {
      final resultado =
          await AuthService.reenviarCodigo(email);

      if (!context.mounted) return;

      mostrarMensaje(
        context,
        resultado['message'] ??
            'Se ha enviado un nuevo código.',
      );
    } catch (e) {
      if (!context.mounted) return;

      mostrarMensaje(
        context,
        'No se pudo reenviar el código.',
      );
    } finally {
      reenviando = false;
    }
  }

  void mostrarMensaje(
    BuildContext context,
    String mensaje,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}