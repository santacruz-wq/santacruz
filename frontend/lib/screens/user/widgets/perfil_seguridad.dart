
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import 'perfil_seccion.dart';

class PerfilSeguridad extends StatelessWidget {
  final String email;

  const PerfilSeguridad({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) => PerfilSeccion(
        titulo: 'Seguridad',
        icono: Icons.lock_outline,
        contenido: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Puedes cambiar tu contraseña verificando tu correo electrónico.',
              style: TextStyle(
                color: AppColors.cafeMedio,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/recuperar',
                  arguments: email,
                ),
                icon: const Icon(Icons.lock_reset_outlined),
                label: const Text('Cambiar contraseña'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.caramelo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
