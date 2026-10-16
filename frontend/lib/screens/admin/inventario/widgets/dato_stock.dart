
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class DatoStock extends StatelessWidget {
  final String titulo;
  final String valor;
  final String unidad;

  const DatoStock({
    super.key,
    required this.titulo,
    required this.valor,
    required this.unidad,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            color: AppColors.cafeMedio,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          valor,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          unidad,
          style: const TextStyle(
            color: AppColors.cafeMedio,
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}
