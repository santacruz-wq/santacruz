import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/language_provider.dart';
import '../../../services/auth_service.dart';

class RegistroController {
  final nombre = TextEditingController();
  final correo = TextEditingController();
  final contrasena = TextEditingController();
  final confirmarContrasena = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool ocultarContrasena = true;
  bool ocultarConfirmarContrasena = true;
  bool cargando = false;

  void dispose() {
    nombre.dispose();
    correo.dispose();
    contrasena.dispose();
    confirmarContrasena.dispose();
  }

  void cambiarContrasena() {
    ocultarContrasena = !ocultarContrasena;
  }

  void cambiarConfirmarContrasena() {
    ocultarConfirmarContrasena =
        !ocultarConfirmarContrasena;
  }

  String? validarRequerido(
    String? value,
    BuildContext context,
  ) {
    if (value == null || value.trim().isEmpty) {
      return context
          .read<LanguageProvider>()
          .t('campo_requerido');
    }

    return null;
  }

  String? validarCorreo(
    String? value,
    BuildContext context,
  ) {
    final lang = context.read<LanguageProvider>();

    if (value == null || value.trim().isEmpty) {
      return lang.t('campo_requerido');
    }

    if (!value.contains('@')) {
      return lang.t('correo_invalido');
    }

    return null;
  }

  String? validarContrasena(
    String? value,
    BuildContext context,
  ) {
    final lang = context.read<LanguageProvider>();

    if (value == null || value.isEmpty) {
      return lang.t('campo_requerido');
    }

    if (value.length < 6) {
      return lang.t('contrasena_corta');
    }

    return null;
  }

  String? validarConfirmacion(
    String? value,
    BuildContext context,
  ) {
    final lang = context.read<LanguageProvider>();

    if (value == null || value.isEmpty) {
      return lang.t('campo_requerido');
    }

    if (value != contrasena.text) {
      return lang.t('contrasenas_no_coinciden');
    }

    return null;
  }

  Future<bool> registrar(BuildContext context) async {
    if (cargando) return false;

    if (!formKey.currentState!.validate()) {
      return false;
    }

    cargando = true;

    try {
      final resultado = await AuthService.registrar(
        nombre.text.trim(),
        correo.text.trim(),
        contrasena.text,
      );

      if (!context.mounted) return false;

      if (resultado['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultado['message'] ??
                  'Cuenta creada. Revisa tu correo para verificarla.',
            ),
            behavior: SnackBarBehavior.floating,
          ),
        );

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!context.mounted) return false;

        Navigator.pushNamed(
          context,
          '/verificar-cuenta',
          arguments: correo.text.trim(),
        );

        return true;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resultado['message'] ??
                'No se pudo registrar la cuenta.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return false;
    } catch (e) {
      if (!context.mounted) return false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo registrar la cuenta. Intenta nuevamente.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return false;
    } finally {
      cargando = false;
    }
  }
}