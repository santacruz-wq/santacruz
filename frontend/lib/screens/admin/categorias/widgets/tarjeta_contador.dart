
import 'package:flutter/material.dart';

class TarjetaContador extends StatelessWidget {
  final String titulo;
  final int cantidad;
  final IconData icono;
  final bool seleccionada;
  final VoidCallback onTap;

  const TarjetaContador({
    super.key,
    required this.titulo,
    required this.cantidad,
    required this.icono,
    required this.seleccionada,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: seleccionada
              ? const Color(0xFFE8DCCB)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: seleccionada
                ? const Color(0xFFC87D32)
                : Colors.brown.shade100,
          ),
        ),
        child: Row(
          children: [
            Icon(icono, color: const Color(0xFF6F4E37)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    titulo,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '$cantidad',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3D2314),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
