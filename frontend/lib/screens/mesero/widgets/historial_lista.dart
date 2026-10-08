import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/orden_model.dart';
import 'historial_tarjeta.dart';

/// Lista de pedidos con el contador "n pedidos encontrados".
class HistorialLista extends StatelessWidget {
  final List<OrdenModel> pedidos;
  final Future<void> Function() onRefresh;
  final void Function(String ordenId) onAbrirDetalle;

  const HistorialLista({
    super.key,
    required this.pedidos,
    required this.onRefresh,
    required this.onAbrirDetalle,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.caramelo,
      onRefresh: onRefresh,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(
          16,
          4,
          16,
          24,
        ),
        itemCount: pedidos.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
                left: 4,
              ),
              child: Text(
                '${pedidos.length} ${pedidos.length == 1 ? 'pedido encontrado' : 'pedidos encontrados'}',
                style: TextStyle(
                  color: AppColors.cafeMedio,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          final orden = pedidos[index - 1];

          return HistorialTarjeta(
            orden: orden,
            onTap: () => onAbrirDetalle(orden.id),
          );
        },
      ),
    );
  }
}