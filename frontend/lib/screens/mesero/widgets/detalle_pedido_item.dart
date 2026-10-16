import 'package:flutter/material.dart';

import '../../../models/orden_detalle_model.dart';
import '../helpers/detalle_colores.dart';

/// Una fila de producto: cantidad, nombre, nota, precio y subtotal.
class DetallePedidoItem extends StatelessWidget {
  final OrdenDetalleModel detalle;

  const DetallePedidoItem({
    super.key,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: DetalleColores.caramelo.withValues(
                alpha: 0.12,
              ),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Text(
              '${detalle.cantidad}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: DetalleColores.caramelo,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  detalle.productoNombre,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: DetalleColores.textoCafe,
                    fontSize: 16,
                  ),
                ),
                if (detalle.notas != null &&
                    detalle.notas!.trim().isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 4,
                    ),
                    child: Text(
                      'Nota: ${detalle.notas}',
                      style: const TextStyle(
                        color: DetalleColores.cafeMedio,
                        fontSize: 13,
                      ),
                    ),
                  ),
                Text(
                  '\$${detalle.precioUnitario.toStringAsFixed(0)} c/u',
                  style: const TextStyle(
                    color: DetalleColores.cafeMedio,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '\$${detalle.subtotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: DetalleColores.textoCafe,
              fontSize: 15,
            ),
          ),
        ],
      ),
    );
  }
}