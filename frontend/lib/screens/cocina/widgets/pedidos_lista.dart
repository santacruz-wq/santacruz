import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import 'pedido_card.dart';

class PedidosLista extends StatelessWidget {
  final List<Map<String, dynamic>> pedidos;
  final Future<void> Function() onRefresh;
  final void Function(OrdenModel orden) onMarcarListo;

  const PedidosLista({
    super.key,
    required this.pedidos,
    required this.onRefresh,
    required this.onMarcarListo,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pedidos.length,
        itemBuilder: (
          context,
          index,
        ) {
          final orden =
              pedidos[index]['orden'] as OrdenModel;

          final detalles = pedidos[index]['detalles']
              as List<OrdenDetalleModel>;

          return PedidoCard(
            orden: orden,
            detalles: detalles,
            onMarcarListo: () => onMarcarListo(orden),
          );
        },
      ),
    );
  }
}