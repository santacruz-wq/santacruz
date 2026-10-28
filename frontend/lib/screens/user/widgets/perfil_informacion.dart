
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_colors.dart';
import '../../../core/config/translation_perfil.dart';
import '../../../providers/language_provider.dart';
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
  Widget build(BuildContext context) {
    final idioma = context.watch<LanguageProvider>().idiomaCodigo;

    String t(String clave) => TranslationPerfil.obtenerTexto(
          clave: clave,
          idioma: idioma,
        );

    return PerfilSeccion(
      titulo: t('informacion_personal'),
      icono: Icons.person_outline,
      contenido: Column(
        children: [
          PerfilFila(
            icono: Icons.badge_outlined,
            titulo: t('nombre_completo'),
            valor: nombre,
          ),
          const Divider(color: AppColors.cremaOscuro),
          PerfilFila(
            icono: Icons.email_outlined,
            titulo: t('correo_electronico'),
            valor: email,
          ),
        ],
      ),
    );
  }
}
