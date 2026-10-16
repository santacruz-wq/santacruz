import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/auth_provider.dart';
import '../../../providers/favorito_provider.dart';
import '../../../providers/language_provider.dart';
import '../utils/auth_navigation.dart';

class LoginController {
  final email = TextEditingController();
  final password = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool ocultarContrasena = true;

  void dispose() {
    email.dispose();
    password.dispose();
  }

  void cambiarVisibilidad() {
    ocultarContrasena = !ocultarContrasena;
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

    return null;
  }

  Future<void> login(
    BuildContext context,
  ) async {
    if (!formKey.currentState!.validate()) {
      return;
    }

    final auth =
        context.read<AuthProvider>();

    final favoritos =
        context.read<FavoritoProvider>();

    final ok = await auth.login(
      email.text.trim(),
      password.text.trim(),
    );

    if (!context.mounted) return;

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            auth.error ??
                "Error al iniciar sesión",
          ),
        ),
      );
      return;
    }

    await favoritos.cargarFavoritos();

    if (!context.mounted) return;

    AuthNavigation.irSegunRol(
      context,
      auth.usuario?.rol,
    );
  }

  Future<void> loginConGoogle(
    BuildContext context,
  ) async {
    final auth =
        context.read<AuthProvider>();

    final favoritos =
        context.read<FavoritoProvider>();

    final ok =
        await auth.loginConGoogle();

    if (!context.mounted) return;

    if (!ok) {
      if (auth.error != null &&
          auth.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(auth.error!),
          ),
        );
      }

      return;
    }

    await favoritos.cargarFavoritos();

    if (!context.mounted) return;

    AuthNavigation.irSegunRol(
      context,
      auth.usuario?.rol,
    );
  }
}
