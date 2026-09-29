import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class AuthFooter extends StatelessWidget {
  final String texto;
  final String accion;
  final String ruta;

  const AuthFooter({
    super.key,
    required this.texto,
    required this.accion,
    required this.ruta,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          texto,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontSize: 14,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              ruta,
            );
          },
          child: Text(
            accion,
            style: const TextStyle(
              color: AppColors.caramelo,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}