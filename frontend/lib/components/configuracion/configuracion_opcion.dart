import 'package:flutter/material.dart';

class ConfiguracionOpcion extends StatelessWidget {
  final IconData icono;
  final String titulo;
  final String subtitulo;
  final bool modoOscuro;
  final VoidCallback onTap;

  const ConfiguracionOpcion({
    super.key,
    required this.icono,
    required this.titulo,
    required this.subtitulo,
    required this.modoOscuro,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cafe = Color(0xFF6F4E37);
    const cafeClaro = Color(0xFF8D6E63);
    const cafeOscuro = Color(0xFF4E342E);
    const crema = Color(0xFFF7F1E8);

    final tarjeta = modoOscuro ? const Color(0xFF2B211D) : Colors.white;

    final textoPrincipal = modoOscuro ? Colors.white : cafeOscuro;

    final textoSecundario = modoOscuro ? Colors.white70 : Colors.grey;

    final iconoFondo = modoOscuro ? const Color(0xFF3A2B25) : crema;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: tarjeta,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: iconoFondo,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  icono,
                  color: modoOscuro ? const Color(0xFFDDB447) : cafe,
                  size: 25,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      titulo,
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitulo,
                      style: TextStyle(
                        color: textoSecundario,
                        fontSize: 13,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(
                Icons.chevron_right,
                color: modoOscuro ? Colors.white54 : cafeClaro,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
