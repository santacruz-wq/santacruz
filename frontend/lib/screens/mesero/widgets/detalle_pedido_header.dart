import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../helpers/detalle_colores.dart';
import '../helpers/detalle_estado.dart';

/// Tarjeta con la mesa, el estado y el mesero.
class DetallePedidoHeader extends StatelessWidget {
  final OrdenModel orden;

  const DetallePedidoHeader({
    super.key,
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    final colorEstado = colorEstadoPedido(orden.estado);

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
            Row(
              children: [
                Expanded(
                  child: Text(
                    orden.mesaNombre.isNotEmpty
                        ? orden.mesaNombre
                        : 'Mesa',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: DetalleColores.textoCafe,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: colorEstado.withValues(
                      alpha: 0.12,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconoEstadoPedido(orden.estado),
                        size: 18,
                        color: colorEstado,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        textoEstadoPedido(orden.estado),
                        style: TextStyle(
                          color: colorEstado,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              'Mesero: ${orden.meseroNombre.isNotEmpty ? orden.meseroNombre : 'Sin asignar'}',
              style: const TextStyle(
                color: DetalleColores.cafeMedio,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}