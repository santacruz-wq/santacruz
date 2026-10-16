import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_model.dart';
import '../../../../models/orden_detalle_model.dart';
import 'pedido_detalle_encabezado.dart';
import 'pedido_detalle_resumen.dart';
import 'pedido_detalle_producto.dart';

class PedidoDetalleSheet extends StatelessWidget {
  final OrdenModel orden;
  final List<OrdenDetalleModel> detalles;

  const PedidoDetalleSheet({
    super.key,
    required this.orden,
    required this.detalles,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.88,
        child: Column(
          children: [
            PedidoDetalleEncabezado(orden: orden),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  PedidoDetalleResumen(orden: orden),
                  const SizedBox(height: 22),
                  const Text(
                    'Productos pedidos',
                    style: TextStyle(
                      color: AppColors.textoCafe,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (detalles.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 24),
                      child: Text(
                        'Este pedido no tiene productos registrados.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.cafeMedio,
                        ),
                      ),
                    )
                  else
                    ...detalles.map(
                      (detalle) => PedidoDetalleProducto(
                        detalle: detalle,
                      ),
                    ),
                  const SizedBox(height: 12),
                  const Divider(thickness: 1),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'TOTAL',
                          style: TextStyle(
                            color: AppColors.textoCafe,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        _precio(orden.total),
                        style: const TextStyle(
                          color: AppColors.cafeMedio,
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _precio(num valor) {
    final numero = valor.round().toString();
    final resultado = numero.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]}.',
    );
    return '\$$resultado';
  }
}