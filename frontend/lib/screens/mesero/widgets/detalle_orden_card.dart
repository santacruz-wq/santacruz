import 'package:flutter/material.dart';

import '../../../models/orden_detalle_model.dart';

/// Tarjeta de un producto dentro de la orden.
class DetalleOrdenCard extends StatelessWidget {
  final OrdenDetalleModel detalle;

  const DetalleOrdenCard({
    super.key,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 10,
      ),
      child: ListTile(
        leading: detalle.esAdicion
            ? const Icon(
                Icons.add_circle,
                color: Colors.orange,
              )
            : const Icon(
                Icons.restaurant,
              ),

        title: Row(
          children: [
            Expanded(
              child: Text(
                detalle.productoNombre,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            if (detalle.esAdicion)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.withAlpha(30),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                ),
                child: const Text(
                  'Adición',
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),

            Text(
              '${detalle.cantidad} x \$${detalle.precioUnitario.toStringAsFixed(0)}',
            ),

            if (detalle.notas != null &&
                detalle.notas!.trim().isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(
                  top: 6,
                ),
                child: Text(
                  '📝 ${detalle.notas}',
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
          ],
        ),

        trailing: Text(
          '\$${detalle.subtotal.toStringAsFixed(0)}',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}