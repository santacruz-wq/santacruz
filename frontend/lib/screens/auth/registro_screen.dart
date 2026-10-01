import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

import 'controllers/registro_controller.dart';
import 'widgets/registro/registro_campos.dart';
import 'widgets/registro/registro_google.dart';
import 'widgets/registro/registro_footer.dart';

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
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.crema,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                RegistroCampos(
                  controller: controller,
                  lang: lang,
                  onCambiarContrasena: () {
                    setState(
                      controller.cambiarContrasena,
                    );
                  },
                  onCambiarConfirmarContrasena: () {
                    setState(
                      controller.cambiarConfirmarContrasena,
                    );
                  },
                  onRegistrar: () async {
                    setState(() {});

                    await controller.registrar(context);

                    if (!mounted) return;

                    setState(() {});
                  },
                ),

                RegistroGoogle(
                  controller: controller,
                  auth: auth,
                ),

                RegistroFooter(
                  lang: lang,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}