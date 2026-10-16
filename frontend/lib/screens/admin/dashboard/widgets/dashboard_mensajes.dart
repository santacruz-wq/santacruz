
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class DashboardMensaje extends StatelessWidget {
  final IconData icono;
  final String mensaje;

  const DashboardMensaje({
    super.key,
    required this.icono,
    required this.mensaje,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cremaClaro,
      elevation: 0,
      child: ListTile(
        leading: Icon(icono, color: AppColors.caramelo),
        title: Text(
          mensaje,
          style: const TextStyle(color: AppColors.textoCafe),
        ),
      ),
    );
  }
}

class DashboardMensajeError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onRetry;

  const DashboardMensajeError({
    super.key,
    required this.mensaje,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cremaClaro,
      child: ListTile(
        leading: const Icon(
          Icons.error_outline,
          color: Colors.red,
        ),
        title: Text(mensaje),
        trailing: IconButton(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}
