import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';
import '../../../../models/orden_detalle_model.dart';
import '../utils/pedidos_formatters.dart';

class PedidoDetalleProducto extends StatelessWidget {
  final OrdenDetalleModel detalle;

  const PedidoDetalleProducto({
    super.key,
    required this.detalle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppColors.crema,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cremaOscuro),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      detalle.productoNombre.isEmpty
                          ? 'Producto no disponible'
                          : detalle.productoNombre,
                      style: const TextStyle(
                        color: AppColors.textoCafe,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '${detalle.cantidad} × '
                      '${PedidosFormatters.precio(detalle.precioUnitario)}',
                      style: const TextStyle(
                        color: AppColors.cafeMedio,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                PedidosFormatters.precio(detalle.subtotal),
                style: const TextStyle(
                  color: AppColors.textoCafe,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          if (detalle.esAdicion) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  Icons.add_circle_outline,
                  size: 16,
                  color: AppColors.caramelo,
                ),
                SizedBox(width: 5),
                Text(
                  'Adición al pedido',
                  style: TextStyle(
                    color: AppColors.caramelo,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
          if (detalle.notas != null &&
              detalle.notas!.trim().isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              'Nota: ${detalle.notas!.trim()}',
              style: const TextStyle(
                color: AppColors.cafeMedio,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }
}