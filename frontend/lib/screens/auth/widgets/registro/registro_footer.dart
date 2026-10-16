
import 'package:flutter/material.dart';

import '../../../../providers/language_provider.dart';

import '../auth_footer.dart';

class RegistroFooter extends StatelessWidget {
  final LanguageProvider lang;

  const RegistroFooter({
    super.key,
    required this.lang,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 24),

        AuthFooter(
          texto: lang.t('ya_tienes_cuenta'),
          accion: lang.t('iniciar_sesion'),
          ruta: '/login',
        ),

        const SizedBox(height: 20),
      ],
    );
  }
}
