
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_colors.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/favorito_provider.dart';

Future<void> cerrarSesionPerfil(BuildContext context) async {
  final confirmar = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.cremaClaro,
      title: const Text(
        'Cerrar sesión',
        style: TextStyle(color: AppColors.textoCafe),
      ),
      content: const Text(
        '¿Estás seguro de que quieres cerrar sesión?',
        style: TextStyle(color: AppColors.textoCafe),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () => Navigator.pop(dialogContext, true),
          child: const Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.red),
          ),
        ),
      ],
    ),
  );

  if (confirmar != true || !context.mounted) return;

  try {
    await context.read<AuthProvider>().logout();
    context.read<FavoritoProvider>().limpiar();

    if (!context.mounted) return;

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/menu',
      (route) => false,
    );
  } catch (e) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'No se pudo cerrar la sesión: '
          '${e.toString().replaceFirst('Exception: ', '')}',
        ),
        backgroundColor: Colors.red.shade700,
      ),
    );
  }
}
