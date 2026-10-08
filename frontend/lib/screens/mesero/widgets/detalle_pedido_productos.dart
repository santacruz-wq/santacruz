import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../helpers/detalle_colores.dart';
import 'detalle_pedido_item.dart';

/// Tarjeta con la lista de productos y el total.
class DetallePedidoProductos extends StatelessWidget {
  final OrdenModel orden;
  final List<OrdenDetalleModel> detalles;

  const DetallePedidoProductos({
    super.key,
    required this.orden,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DetalleColores.cremaClaro,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Productos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: DetalleColores.textoCafe,
              ),
            ),
            const SizedBox(height: 14),
            ...detalles.map(
              (detalle) => DetallePedidoItem(
                detalle: detalle,
              ),
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: DetalleColores.textoCafe,
                  ),
                ),
                Text(
                  '\$${orden.total.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: DetalleColores.caramelo,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}