import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../providers/language_provider.dart';

import 'controllers/registro_controller.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class RegistroScreen extends StatefulWidget {
  const RegistroScreen({super.key});

  @override
  State<RegistroScreen> createState() => _RegistroScreenState();
}

class _RegistroScreenState extends State<RegistroScreen> {
  final controller = RegistroController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.crema,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),

                AuthHeader(
                  titulo: lang.t('crear_cuenta'),
                  subtitulo: lang.t('bienvenido'),
                ),

                const SizedBox(height: 30),

                // NOMBRE
                AuthTextField(
                  controller: controller.nombre,
                  hintText: lang.t('nombre'),
                  icon: Icons.person_outline,
                  validator: (value) =>
                      controller.validarRequerido(
                    value,
                    context,
                  ),
                ),

                const SizedBox(height: 18),

                // CORREO
                AuthTextField(
                  controller: controller.correo,
                  hintText: lang.t('correo'),
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) =>
                      controller.validarCorreo(
                    value,
                    context,
                  ),
                ),

                const SizedBox(height: 18),

                // CONTRASEÑA
                AuthTextField(
                  controller: controller.contrasena,
                  hintText: lang.t('contrasena'),
                  icon: Icons.lock_outline,
                  obscureText:
                      controller.ocultarContrasena,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        controller.cambiarContrasena,
                      );
                    },
                    icon: Icon(
                      controller.ocultarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.cafeMedio,
                    ),
                  ),
                  validator: (value) =>
                      controller.validarContrasena(
                    value,
                    context,
                  ),
                ),

                const SizedBox(height: 18),

                // CONFIRMAR CONTRASEÑA
                AuthTextField(
                  controller:
                      controller.confirmarContrasena,
                  hintText:
                      lang.t('confirmar_contrasena'),
                  icon: Icons.lock_outline,
                  obscureText:
                      controller
                          .ocultarConfirmarContrasena,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        controller
                            .cambiarConfirmarContrasena,
                      );
                    },
                    icon: Icon(
                      controller
                              .ocultarConfirmarContrasena
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: AppColors.cafeMedio,
                    ),
                  ),
                  validator: (value) =>
                      controller.validarConfirmacion(
                    value,
                    context,
                  ),
                ),

                const SizedBox(height: 28),

                // REGISTRARSE
                AuthButton(
                  texto: lang.t('registrarse'),
                  cargando: controller.cargando,
                  onPressed: () async {
                    setState(() {});

                    await controller.registrar(context);

                    if (!mounted) return;

                    setState(() {});
                  },
                ),

                const SizedBox(height: 24),

                // YA TIENE CUENTA
                AuthFooter(
                  texto: lang.t('ya_tienes_cuenta'),
                  accion: lang.t('iniciar_sesion'),
                  ruta: '/login',
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}