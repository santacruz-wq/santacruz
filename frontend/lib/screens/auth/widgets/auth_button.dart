import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class AuthButton extends StatelessWidget {
  final String texto;
  final bool cargando;
  final VoidCallback onPressed;

  const AuthButton({
    super.key,
    required this.texto,
    required this.cargando,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const CircularProgressIndicator(
        color: AppColors.caramelo,
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.textoCafe,
          foregroundColor: AppColors.blanco,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          texto,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}