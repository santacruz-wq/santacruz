
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../providers/language_provider.dart';

import '../../controllers/registro_controller.dart';
import '../auth_button.dart';
import '../auth_header.dart';
import '../auth_text_field.dart';

class RegistroCampos extends StatelessWidget {
  final RegistroController controller;
  final LanguageProvider lang;

  final VoidCallback onCambiarContrasena;
  final VoidCallback onCambiarConfirmarContrasena;
  final VoidCallback onRegistrar;

  const RegistroCampos({
    super.key,
    required this.controller,
    required this.lang,
    required this.onCambiarContrasena,
    required this.onCambiarConfirmarContrasena,
    required this.onRegistrar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        AuthHeader(
          titulo: lang.t('crear_cuenta'),
          subtitulo: lang.t('bienvenido'),
        ),

        const SizedBox(height: 30),

        AuthTextField(
          controller: controller.nombre,
          hintText: lang.t('nombre'),
          icon: Icons.person_outline,
          validator: (value) => controller.validarRequerido(
            value,
            context,
          ),
        ),

        const SizedBox(height: 18),

        AuthTextField(
          controller: controller.correo,
          hintText: lang.t('correo'),
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: (value) => controller.validarCorreo(
            value,
            context,
          ),
        ),

        const SizedBox(height: 18),

        AuthTextField(
          controller: controller.contrasena,
          hintText: lang.t('contrasena'),
          icon: Icons.lock_outline,
          obscureText: controller.ocultarContrasena,
          suffixIcon: IconButton(
            onPressed: onCambiarContrasena,
            icon: Icon(
              controller.ocultarContrasena
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.cafeMedio,
            ),
          ),
          validator: (value) => controller.validarContrasena(
            value,
            context,
          ),
        ),

        const SizedBox(height: 18),

        AuthTextField(
          controller: controller.confirmarContrasena,
          hintText: lang.t('confirmar_contrasena'),
          icon: Icons.lock_outline,
          obscureText: controller.ocultarConfirmarContrasena,
          suffixIcon: IconButton(
            onPressed: onCambiarConfirmarContrasena,
            icon: Icon(
              controller.ocultarConfirmarContrasena
                  ? Icons.visibility_off_outlined
                  : Icons.visibility_outlined,
              color: AppColors.cafeMedio,
            ),
          ),
          validator: (value) => controller.validarConfirmacion(
            value,
            context,
          ),
        ),

        const SizedBox(height: 28),

        AuthButton(
          texto: lang.t('registrarse'),
          cargando: controller.cargando,
          onPressed: onRegistrar,
        ),
      ],
    );
  }
}