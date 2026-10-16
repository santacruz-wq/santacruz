
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../providers/auth_provider.dart';

import '../../controllers/registro_controller.dart';
import '../google_auth_button.dart';

class RegistroGoogle extends StatelessWidget {
  final RegistroController controller;
  final AuthProvider auth;

  const RegistroGoogle({
    super.key,
    required this.controller,
    required this.auth,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: Divider(
                color: AppColors.cafeMedio.withOpacity(0.3),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              child: Text(
                'o',
                style: TextStyle(
                  color: AppColors.cafeMedio,
                ),
              ),
            ),

            Expanded(
              child: Divider(
                color: AppColors.cafeMedio.withOpacity(0.3),
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        GoogleAuthButton(
          texto: 'Registrarme con Google',
          cargando: auth.cargando,
          onPressed: () => controller.registroConGoogle(
            context,
          ),
        ),
      ],
    );
  }
}
