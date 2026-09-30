import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String titulo;
  final String subtitulo;

  const AuthHeader({
    super.key,
    required this.titulo,
    required this.subtitulo,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
          height: 120,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 18),
        Text(
          titulo,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitulo,
          style: TextStyle(
            color: AppColors.cafeMedio.withOpacity(0.8),
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}