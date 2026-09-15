
import 'package:flutter/material.dart';

class DetalleProductoImagen extends StatelessWidget {
  final IconData icono;
  final bool oscuro;

  const DetalleProductoImagen({
    super.key,
    required this.icono,
    required this.oscuro,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 280,
      decoration: BoxDecoration(
        color: oscuro
            ? const Color(0xFF3A2B25)
            : const Color(0xFFF7F1E8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Icon(
        icono,
        size: 130,
        color: const Color(0xFF6F4E37),
      ),
    );
  }
}





