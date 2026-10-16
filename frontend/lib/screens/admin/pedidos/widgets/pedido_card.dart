
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_model.dart';
import '../utils/pedidos_formatters.dart';

class PedidoCard extends StatelessWidget {
  final OrdenModel orden;
  final VoidCallback onTap;

  const PedidoCard({
    super.key,
    required this.orden,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = PedidosFormatters.colorEstado(orden.estado);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.cremaClaro,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.cremaOscuro),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.carameloClaro.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.receipt_long,
                      color: AppColors.cafeMedio,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pedido',
                          style: TextStyle(
                            color: AppColors.textoCafe,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'N.º ${PedidosFormatters.idCorto(orden.id)}',
                          style: const TextStyle(
                            color: AppColors.cafeMedio,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          PedidosFormatters.fecha(orden.createdAt),
                          style: const TextStyle(
                            color: AppColors.cafeMedio,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        PedidosFormatters.nombreEstado(orden.estado),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: color,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Divider(height: 1),
              const SizedBox(height: 12),
              _dato(Icons.table_restaurant_outlined, orden.mesaNombre,
                  'Mesa sin nombre'),
              const SizedBox(height: 8),
              _dato(Icons.person_outline, orden.meseroNombre,
                  'Mesero no disponible'),
              const SizedBox(height: 13),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Total del pedido',
                      style: TextStyle(
                        color: AppColors.textoCafe,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    PedidosFormatters.precio(orden.total),
                    style: const TextStyle(
                      color: AppColors.cafeMedio,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Ver detalle',
                      style: TextStyle(
                        color: AppColors.caramelo,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: AppColors.caramelo,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dato(IconData icono, String valor, String alternativo) {
    return Row(
      children: [
        Icon(icono, size: 19, color: AppColors.cafeMedio),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            valor.isEmpty ? alternativo : valor,
            style: const TextStyle(color: AppColors.textoCafe),
          ),
        ),
      ],
    );
  }
}
