import 'package:flutter/material.dart';

class PedidosError extends StatelessWidget {
  final VoidCallback onReintentar;

  const PedidosError({
    super.key,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'No se pudieron cargar los pedidos',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReintentar,
            child: const Text(
              'Reintentar',
            ),
          ),
        ],
      ),
    );
  }
}