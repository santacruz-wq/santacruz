
import 'package:flutter/material.dart';

class DetalleProductoCantidad extends StatelessWidget {
  final int cantidad;
  final bool oscuro;
  final String titulo;
  final VoidCallback onDisminuir;
  final VoidCallback onAumentar;

  const DetalleProductoCantidad({
    super.key,
    required this.cantidad,
    required this.oscuro,
    required this.titulo,
    required this.onDisminuir,
    required this.onAumentar,
  });

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color dorado = Color(0xFFDDB447);

  @override
  Widget build(BuildContext context) {
    final Color textoPrincipal =
        oscuro ? Colors.white : cafeOscuro;

    final Color colorBoton =
        oscuro ? dorado : cafe;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: textoPrincipal,
          ),
        ),

        const SizedBox(height: 10),

        Row(
          children: [
            IconButton(
              onPressed: onDisminuir,
              icon: Icon(
                Icons.remove_circle_outline,
                size: 32,
                color: colorBoton,
              ),
            ),

            Text(
              '$cantidad',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: textoPrincipal,
              ),
            ),

            IconButton(
              onPressed: onAumentar,
              icon: Icon(
                Icons.add_circle_outline,
                size: 32,
                color: colorBoton,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

