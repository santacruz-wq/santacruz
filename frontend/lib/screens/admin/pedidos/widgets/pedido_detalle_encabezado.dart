import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_model.dart';

class PedidoDetalleEncabezado extends StatelessWidget {
  final OrdenModel orden;

  const PedidoDetalleEncabezado({
    super.key,
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Detalle del pedido',
                  style: TextStyle(
                    color: AppColors.textoCafe,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'N.º ${orden.id}',
                  style: const TextStyle(
                    color: AppColors.cafeMedio,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Cerrar',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }
}