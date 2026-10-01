import 'package:flutter/material.dart';

import '../../models/producto_model.dart';

class ProductoCard extends StatelessWidget {
  final ProductoModel producto;
  final VoidCallback onAgregar;

  const ProductoCard({
    super.key,
    required this.producto,
    required this.onAgregar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // IMAGEN DEL PRODUCTO
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 80,
                height: 80,
                child: producto.imagen.isNotEmpty
                    ? Image.network(
                        producto.imagen,
                        fit: BoxFit.cover,
                        errorBuilder: (
                          context,
                          error,
                          stackTrace,
                        ) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 35,
                          );
                        },
                      )
                    : const Icon(
                        Icons.image_outlined,
                        size: 35,
                      ),
              ),
            ),

            const SizedBox(width: 12),

            // INFORMACIÓN DEL PRODUCTO
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    producto.nombre,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    producto.descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    '\$${producto.precio.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // BOTÓN AGREGAR
            IconButton(
              onPressed: onAgregar,
              icon: const Icon(
                Icons.add_circle,
                size: 32,
              ),
              tooltip: 'Agregar',
            ),
          ],
        ),
      ),
    );
  }
}