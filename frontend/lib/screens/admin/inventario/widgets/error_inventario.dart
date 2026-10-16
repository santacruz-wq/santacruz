
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class ErrorInventario extends StatelessWidget {
  final Future<void> Function() onReintentar;

  const ErrorInventario({
    super.key,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 50,
              color: Colors.red,
            ),
            const SizedBox(height: 12),
            const Text(
              'No se pudo cargar el inventario',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textoCafe,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.caramelo,
                foregroundColor: Colors.white,
              ),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
