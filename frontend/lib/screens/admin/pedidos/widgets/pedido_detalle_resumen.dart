import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_model.dart';
import '../utils/pedidos_formatters.dart';

class PedidoDetalleResumen extends StatelessWidget {
  final OrdenModel orden;

  const PedidoDetalleResumen({
    super.key,
    required this.orden,
  });

  @override
  Widget build(BuildContext context) {
    final color = PedidosFormatters.colorEstado(orden.estado);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.crema,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          _filaDato('Mesa', orden.mesaNombre),
          _filaDato('Mesero', orden.meseroNombre),
          _filaDato(
            'Fecha',
            PedidosFormatters.fecha(orden.createdAt),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Estado',
                    style: TextStyle(color: AppColors.cafeMedio),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    PedidosFormatters.nombreEstado(orden.estado),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _filaDato(String etiqueta, String valor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              etiqueta,
              style: const TextStyle(color: AppColors.cafeMedio),
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              valor.isEmpty ? 'No disponible' : valor,
              textAlign: TextAlign.end,
              style: const TextStyle(
                color: AppColors.textoCafe,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}