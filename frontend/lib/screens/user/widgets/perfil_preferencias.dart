
import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import 'perfil_seccion.dart';

class PerfilPreferencias extends StatelessWidget {
  final int totalFavoritos;
  final String idioma;
  final String rol;
  final bool esPersonal;

  const PerfilPreferencias({
    super.key,
    required this.totalFavoritos,
    required this.idioma,
    required this.rol,
    required this.esPersonal,
  });

  @override
  Widget build(BuildContext context) => PerfilSeccion(
        titulo: 'Preferencias',
        icono: Icons.tune,
        contenido: Column(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.favorite_border,
                color: AppColors.caramelo,
              ),
              title: const Text(
                'Mis favoritos',
                style: TextStyle(color: AppColors.textoCafe),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$totalFavoritos',
                    style: const TextStyle(
                      color: AppColors.caramelo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.cafeMedio,
                  ),
                ],
              ),
              onTap: () => Navigator.pushNamed(context, '/favoritos'),
            ),
            const Divider(color: AppColors.cremaOscuro),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.language,
                color: AppColors.caramelo,
              ),
              title: const Text(
                'Idioma',
                style: TextStyle(color: AppColors.textoCafe),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    idioma,
                    style: const TextStyle(
                      color: AppColors.caramelo,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.cafeMedio,
                  ),
                ],
              ),
              onTap: () =>
                  Navigator.pushNamed(context, '/language-selection'),
            ),
            if (esPersonal) ...[
              const Divider(color: AppColors.cremaOscuro),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(
                  Icons.badge_outlined,
                  color: AppColors.caramelo,
                ),
                title: const Text(
                  'Rol',
                  style: TextStyle(color: AppColors.textoCafe),
                ),
                trailing: Text(
                  rol,
                  style: const TextStyle(
                    color: AppColors.caramelo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      );
}
