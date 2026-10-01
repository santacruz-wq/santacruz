import 'package:flutter/material.dart';
import '../../screens/language_selection/language_selection.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: () {
          //NAVEGACION DIRECTA A LA PANTALLA, SIN USAR LA RUTA CON NOMBRE
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const LanguageSelectionScreen(),
            ),
          );
        },
        icon: const Icon(
          Icons.language,
          color: Colors.white,
          size: 22,
        ),
        tooltip: 'Cambiar idioma',
      ),
    );
  }
}