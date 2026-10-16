import 'package:flutter/material.dart';

class PedidosVacios extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const PedidosVacios({
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
          SizedBox(height: 180),
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.restaurant,
                  size: 60,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'No hay pedidos pendientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Los nuevos pedidos aparecerán aquí.',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}