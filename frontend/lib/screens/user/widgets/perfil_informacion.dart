
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import 'perfil_seccion.dart';

class PerfilInformacion extends StatelessWidget {
  final String nombre;
  final String email;

  const PerfilInformacion({
    super.key,
    required this.nombre,
    required this.email,
  });

  @override
  Widget build(BuildContext context) => PerfilSeccion(
        titulo: 'Información personal',
        icono: Icons.person_outline,
        contenido: Column(
          children: [
            PerfilFila(
              icono: Icons.badge_outlined,
              titulo: 'Nombre completo',
              valor: nombre,
            ),
            const Divider(color: AppColors.cremaOscuro),
            PerfilFila(
              icono: Icons.email_outlined,
              titulo: 'Correo electrónico',
              valor: email,
            ),
          ],
        ),
      );
}
