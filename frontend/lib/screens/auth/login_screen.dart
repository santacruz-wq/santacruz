
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import 'controllers/login_controller.dart';
import 'widgets/auth_button.dart';
import 'widgets/auth_footer.dart';
import 'widgets/auth_header.dart';
import 'widgets/auth_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final controller = LoginController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
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
                  titulo: lang.t('iniciar_sesion'),
                  subtitulo: lang.t('bienvenido'),
                ),

                const SizedBox(height: 30),

                // CORREO
                AuthTextField(
                  controller: controller.email,
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
                  controller: controller.password,
                  hintText: lang.t('contrasena'),
                  icon: Icons.lock_outline,
                  obscureText:
                      controller.ocultarContrasena,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(
                        controller.cambiarVisibilidad,
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

                // RECUPERAR CONTRASEÑA
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        "/recuperar",
                      );
                    },
                    child: Text(
                      lang.t('olvidaste_contrasena'),
                      style: const TextStyle(
                        color: AppColors.caramelo,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // LOGIN NORMAL
                AuthButton(
                  texto: lang.t('iniciar_sesion'),
                  cargando: auth.cargando,
                  onPressed: () =>
                      controller.login(context),
                ),

                const SizedBox(height: 20),

                // SEPARADOR
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: AppColors.cafeMedio
                            .withOpacity(0.35),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                      ),
                      child: Text(
                        'o',
                        style: TextStyle(
                          color: AppColors.cafeMedio,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: AppColors.cafeMedio
                            .withOpacity(0.35),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // GOOGLE
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: auth.cargando
                        ? null
                        : () => controller
                            .loginConGoogle(context),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(
                        color: AppColors.cafeMedio
                            .withOpacity(0.35),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          child: const Text(
                            'G',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF4285F4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'Continuar con Google',
                          style: TextStyle(
                            color: Color(0xFF3C4043),
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // REGISTRO
                AuthFooter(
                  texto: lang.t('no_tienes_cuenta'),
                  accion: lang.t('registrarse'),
                  ruta: "/registro",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}