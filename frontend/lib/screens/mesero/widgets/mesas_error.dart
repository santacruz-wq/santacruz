import 'package:flutter/material.dart';

class MesasError extends StatelessWidget {
  final VoidCallback onReintentar;

  const MesasError({
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
            'No se pudieron cargar las mesas',
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