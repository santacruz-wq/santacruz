import 'package:flutter/material.dart';

import '../../../models/orden_detalle_model.dart';
import '../helpers/detalle_colores.dart';

/// Una línea de producto: "2 × Nombre ........ $subtotal".
class PedidoActivoProducto extends StatelessWidget {
  final OrdenDetalleModel detalle;

  const PedidoActivoProducto({
    super.key,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${detalle.cantidad} × ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: DetalleColores.textoCafe,
            ),
          ),
          Expanded(
            child: Text(
              detalle.productoNombre,
              style: const TextStyle(
                color: DetalleColores.textoCafe,
              ),
            ),
          ),
          Text(
            '\$${detalle.subtotal.toStringAsFixed(0)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: DetalleColores.textoCafe,
            ),
          ),
        ],
      ),
    );
  }
}