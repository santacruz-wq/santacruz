import 'package:flutter/material.dart';

class ProductosError extends StatelessWidget {
  final VoidCallback onReintentar;

  const ProductosError({
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
            'No se pudieron cargar los productos',
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