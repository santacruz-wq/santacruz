import 'package:flutter/material.dart';

class OrdenError extends StatelessWidget {
  final VoidCallback onReintentar;

  const OrdenError({
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
            'No se pudo cargar la orden',
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onReintentar,
            child: const Text('Reintentar'),
          ),
        ],
      ),
    );
  }
}