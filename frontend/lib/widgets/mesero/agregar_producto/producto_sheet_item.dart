import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';

/// Tarjeta de un producto dentro del sheet: imagen, precio,
/// botones +/- y campo de nota cuando hay cantidad.
class ProductoSheetItem extends StatelessWidget {
  final ProductoModel producto;
  final int cantidad;
  final TextEditingController? notaController;
  final VoidCallback onAumentar;
  final VoidCallback onDisminuir;

  const ProductoSheetItem({
    super.key,
    required this.producto,
    required this.cantidad,
    required this.notaController,
    required this.onAumentar,
    required this.onDisminuir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      child: Padding(
        padding: const EdgeInsets.all(
          10,
        ),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  child: SizedBox(
                    width: 60,
                    height: 60,
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
                              );
                            },
                          )
                        : const Icon(
                            Icons.image_outlined,
                          ),
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '\$${producto.precio.toStringAsFixed(0)}',
                      ),
                    ],
                  ),
                ),

                IconButton(
                  onPressed:
                      cantidad > 0 ? onDisminuir : null,
                  icon: const Icon(
                    Icons.remove_circle_outline,
                  ),
                ),

                Text(
                  '$cantidad',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                IconButton(
                  onPressed: onAumentar,
                  icon: const Icon(
                    Icons.add_circle_outline,
                  ),
                ),
              ],
            ),

            if (cantidad > 0) ...[
              const SizedBox(
                height: 10,
              ),

              TextField(
                controller: notaController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Nota para cocina (opcional)',
                  hintText: 'Ej: Agregar una porción de coco',
                  prefixIcon: const Icon(
                    Icons.note_alt_outlined,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}