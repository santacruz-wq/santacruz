
import 'package:flutter/material.dart';

class DetalleProductoInfo extends StatelessWidget {
  final String nombre;
  final String precio;
  final String descripcion;
  final bool oscuro;

  const DetalleProductoInfo({
    super.key,
    required this.nombre,
    required this.precio,
    required this.descripcion,
    required this.oscuro,
  });

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color dorado = Color(0xFFDDB447);

  @override
  Widget build(BuildContext context) {
    final Color textoPrincipal =
        oscuro ? Colors.white : cafeOscuro;

    final Color textoSecundario =
        oscuro ? Colors.white70 : const Color(0xFF6D625D);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          nombre,
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: textoPrincipal,
          ),
        ),

        const SizedBox(height: 10),

        Text(
          precio,
          style: const TextStyle(
            color: dorado,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 25),

        Text(
          'Descripción',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textoPrincipal,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          descripcion,
          style: TextStyle(
            fontSize: 16,
            color: textoSecundario,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

