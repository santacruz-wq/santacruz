
import 'package:flutter/material.dart';

class ConfirmarTotal extends StatelessWidget {
  final double total;

  final String titulo;
  final String Function(double precio) formatoPrecio;

  final Color cafeOscuro;
  final Color crema;
  final Color dorado;

  const ConfirmarTotal({
    super.key,
    required this.total,
    required this.titulo,
    required this.formatoPrecio,
    required this.cafeOscuro,
    required this.crema,
    required this.dorado,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: crema,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dorado.withOpacity(0.45),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            titulo,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: cafeOscuro,
            ),
          ),
          Text(
            formatoPrecio(total),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: dorado,
            ),
          ),
        ],
      ),
    );
  }
}

