import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../helpers/detalle_colores.dart';
import '../helpers/detalle_estado.dart';
import 'pedido_activo_producto.dart';

/// Tarjeta de un pedido activo: mesa, estado, mesero, productos y total.
class PedidoActivoCard extends StatelessWidget {
  final OrdenModel orden;
  final List<OrdenDetalleModel> detalles;
  final VoidCallback onTap;

  const PedidoActivoCard({
    super.key,
    required this.orden,
    required this.detalles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const textoCafe = DetalleColores.textoCafe;
    const cafeMedio = DetalleColores.cafeMedio;
    const caramelo = DetalleColores.caramelo;

    final colorEstado = colorEstadoPedido(orden.estado);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        color: DetalleColores.cremaClaro,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
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
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: textoCafe,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
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
                          size: 17,
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
              const SizedBox(height: 8),
              Text(
                'Mesero: ${orden.meseroNombre.isNotEmpty ? orden.meseroNombre : 'Sin asignar'}',
                style: const TextStyle(
                  color: cafeMedio,
                ),
              ),
              const Divider(height: 24),
              ...detalles.map(
                (detalle) => PedidoActivoProducto(
                  detalle: detalle,
                ),
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: textoCafe,
                    ),
                  ),
                  Text(
                    '\$${orden.total.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: caramelo,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}