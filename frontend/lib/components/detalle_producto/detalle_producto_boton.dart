
import 'package:flutter/material.dart';

class DetalleProductoBoton extends StatelessWidget {
  final String texto;
  final VoidCallback onPressed;

  const DetalleProductoBoton({
    super.key,
    required this.texto,
    required this.onPressed,
  });

  static const Color cafe = Color(0xFF6F4E37);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(
          Icons.shopping_cart,
        ),
        label: Text(
          texto.toUpperCase(),
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: cafe,
          foregroundColor: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
      ),
    );
  }
}

