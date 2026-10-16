import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import 'pedido_activo_card.dart';

/// Lista de pedidos activos con pull-to-refresh.
class PedidosActivosLista extends StatelessWidget {
  final List<Map<String, dynamic>> pedidos;
  final Future<void> Function() onRefresh;
  final void Function(String ordenId) onAbrirDetalle;

  const PedidosActivosLista({
    super.key,
    required this.pedidos,
    required this.onRefresh,
    required this.onAbrirDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        itemCount: pedidos.length,
        itemBuilder: (context, index) {
          final orden = pedidos[index]['orden'] as OrdenModel;

          final detalles =
              pedidos[index]['detalles'] as List<OrdenDetalleModel>;

          return PedidoActivoCard(
            orden: orden,
            detalles: detalles,
            onTap: () => onAbrirDetalle(orden.id),
          );
        },
      ),
    );
  }
}