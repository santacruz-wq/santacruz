import 'package:flutter/material.dart';

class PerfilOpcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;
  final bool oscuro;

  const PerfilOpcion({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
    required this.oscuro,
  });

  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color dorado = Color(0xFFDDB447);
  static const Color doradoClaro = Color(0xFFF3D27A);

  @override
  Widget build(BuildContext context) {
    final Color fondoIcono = oscuro ? const Color(0xFF3A2C26) : crema;

    final Color colorTitulo = oscuro ? Colors.white : const Color(0xFF4E342E);

    final Color colorSubtitulo = oscuro ? const Color(0xFFD7C4BA) : cafeClaro;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // ICONO
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: oscuro
                      ? [cafe.withOpacity(0.75), const Color(0xFF3A2C26)]
                      : [doradoClaro.withOpacity(0.45), fondoIcono],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icono, color: oscuro ? dorado : cafe, size: 27),
            ),

            const SizedBox(width: 14),

            // INFORMACIÓN
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: TextStyle(
                      color: colorTitulo,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    subtitulo,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: colorSubtitulo, fontSize: 13),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // FLECHA
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                color: oscuro ? cafe.withOpacity(0.25) : crema,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 14,
                color: oscuro ? dorado : cafeClaro,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
