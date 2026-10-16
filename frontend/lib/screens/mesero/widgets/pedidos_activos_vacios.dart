import 'package:flutter/material.dart';

import '../helpers/detalle_colores.dart';

class PedidosActivosVacios extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const PedidosActivosVacios({
    super.key,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 150),
          Icon(
            Icons.receipt_long_outlined,
            size: 70,
            color: DetalleColores.cafeMedio,
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              'No hay pedidos activos',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: DetalleColores.textoCafe,
              ),
            ),
          ),
          SizedBox(height: 8),
          Center(
            child: Text(
              'Los nuevos pedidos aparecerán aquí.',
              style: TextStyle(
                color: DetalleColores.cafeMedio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}