import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';
import '../../../widgets/mesero/producto_card.dart';
import 'nota_box.dart';

/// Producto de la lista con sus controles de cantidad y nota.
class ProductoOrdenItem extends StatelessWidget {
  final ProductoModel producto;
  final int cantidad;
  final String? nota;
  final VoidCallback onAgregar;
  final VoidCallback onQuitar;
  final VoidCallback onEditarNota;

  const ProductoOrdenItem({
    super.key,
    required this.producto,
    required this.cantidad,
    required this.nota,
    required this.onAgregar,
    required this.onQuitar,
    required this.onEditarNota,
  });

  @override
  Widget build(BuildContext context) {
    final nota = this.nota;

    return Column(
      children: [
        ProductoCard(
          producto: producto,
          onAgregar: () => onAgregar(),
        ),

        if (cantidad > 0)
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: onQuitar,
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
                    onPressed: onAgregar,
                    icon: const Icon(
                      Icons.add_circle_outline,
                    ),
                  ),

                  const SizedBox(
                    width: 8,
                  ),

                  // BOTÓN DE NOTA
                  IconButton(
                    tooltip: 'Agregar nota',
                    onPressed: onEditarNota,
                    icon: Icon(
                      nota != null && nota.isNotEmpty
                          ? Icons.sticky_note_2
                          : Icons.edit_note,
                      size: 28,
                    ),
                  ),
                ],
              ),

              // MOSTRAR NOTA
              if (nota != null && nota.isNotEmpty)
                NotaBox(
                  nota: nota,
                  onEditar: onEditarNota,
                ),
            ],
          ),
      ],
    );
  }
}