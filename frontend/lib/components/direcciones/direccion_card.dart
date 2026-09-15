import 'package:flutter/material.dart';

class DireccionCard extends StatelessWidget {
  final Map<String, String> direccion;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const DireccionCard({
    super.key,
    required this.direccion,
    required this.onEditar,
    required this.onEliminar,
  });

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6D4C41);
  static const Color crema = Color(0xFFFFF8E7);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: crema,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.location_on_outlined,
                  color: cafe,
                  size: 25,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      direccion['direccion'] ?? '',
                      style: const TextStyle(
                        color: cafeOscuro,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Barrio: ${direccion['barrio'] ?? ''}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                    if ((direccion['referencia'] ?? '').isNotEmpty) ...[
                      const SizedBox(height: 5),
                      Text(
                        'Referencia: ${direccion['referencia']}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(
            height: 1,
            color: Color(0xFFE5D5C8),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onEditar,
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 17,
                  color: cafe,
                ),
                label: const Text(
                  'Editar',
                  style: TextStyle(
                    color: cafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              TextButton.icon(
                onPressed: onEliminar,
                icon: const Icon(
                  Icons.delete_outline,
                  size: 17,
                  color: Colors.red,
                ),
                label: const Text(
                  'Eliminar',
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}