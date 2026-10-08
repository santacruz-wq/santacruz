import 'package:flutter/material.dart';

import '../helpers/detalle_colores.dart';

class DetallePedidoError extends StatelessWidget {
  final Object? error;
  final VoidCallback onReintentar;

  const DetallePedidoError({
    super.key,
    required this.error,
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
              'No se pudo cargar el pedido',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: DetalleColores.textoCafe,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: DetalleColores.cafeMedio,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onReintentar,
              style: ElevatedButton.styleFrom(
                backgroundColor: DetalleColores.caramelo,
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