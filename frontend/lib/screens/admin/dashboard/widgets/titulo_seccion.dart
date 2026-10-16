
import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class TituloSeccion extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const TituloSeccion({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textoCafe,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitulo,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.cafeMedio,
          ),
        ),
      ],
    );
  }
}
