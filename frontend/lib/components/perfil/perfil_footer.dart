import 'package:flutter/material.dart';

class PerfilFooter extends StatelessWidget {
  final bool oscuro;

  const PerfilFooter({super.key, required this.oscuro});

  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color dorado = Color(0xFFDDB447);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.coffee_outlined,
          size: 16,
          color: oscuro ? dorado : cafeClaro,
        ),
        const SizedBox(width: 6),
        Text(
          'Santa Cruz',
          style: TextStyle(
            color: oscuro ? const Color(0xFFD7C4BA) : cafeClaro,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
