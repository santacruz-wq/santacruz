
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/producto_mas_vendido_model.dart';
import 'dashboard_mensajes.dart';

class DashboardProductos extends StatelessWidget {
  final List<ProductoMasVendidoModel> productos;
  final bool cargando;
  final String? error;
  final String Function(num) formatearPesos;
  final VoidCallback onRetry;

  const DashboardProductos({
    super.key,
    required this.productos,
    required this.cargando,
    required this.error,
    required this.formatearPesos,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Productos más vendidos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textoCafe,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Según las órdenes pagadas',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.cafeMedio,
          ),
        ),
        const SizedBox(height: 12),
        if (error != null)
          DashboardMensajeError(
            mensaje: error!,
            onRetry: onRetry,
          )
        else if (productos.isEmpty && !cargando)
          const DashboardMensaje(
            icono: Icons.bar_chart,
            mensaje:
                'Todavía no hay ventas pagadas de productos para mostrar.',
          )
        else
          ...productos.asMap().entries.map((entry) {
            final indice = entry.key;
            final producto = entry.value;

            return Card(
              color: AppColors.cremaClaro,
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppColors.cremaOscuro,
                  child: Text(
                    '${indice + 1}',
                    style: const TextStyle(
                      color: AppColors.textoCafe,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  producto.nombre,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${producto.cantidadVendida} unidades vendidas',
                  style: const TextStyle(
                    color: AppColors.cafeMedio,
                  ),
                ),
                trailing: Text(
                  formatearPesos(producto.totalVendido),
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
