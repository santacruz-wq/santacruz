
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/inventario_model.dart';
import 'dashboard_mensajes.dart';

class DashboardInventario extends StatelessWidget {
  final String? error;
  final List<InventarioModel> agotados;
  final List<InventarioModel> stockBajo;
  final List<InventarioModel> alertas;
  final VoidCallback onRetry;
  final VoidCallback onVerStock;

  const DashboardInventario({
    super.key,
    required this.error,
    required this.agotados,
    required this.stockBajo,
    required this.alertas,
    required this.onRetry,
    required this.onVerStock,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Alertas de inventario',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textoCafe,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Productos e insumos por revisar',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.cafeMedio,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onVerStock,
              child: const Text('Ver stock'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (error != null)
          DashboardMensajeError(
            mensaje: error!,
            onRetry: onRetry,
          )
        else if (alertas.isEmpty)
          const DashboardMensaje(
            icono: Icons.inventory_2_outlined,
            mensaje: 'No hay alertas de inventario.',
          )
        else ...[
          _TarjetaAlerta(
            titulo: 'Stock agotado',
            cantidad: agotados.length,
            icono: Icons.error_outline,
            agotado: true,
          ),
          const SizedBox(height: 8),
          _TarjetaAlerta(
            titulo: 'Stock bajo',
            cantidad: stockBajo.length,
            icono: Icons.warning_amber_rounded,
            agotado: false,
          ),
          const SizedBox(height: 8),
          ...alertas.take(5).map(
            (item) => Card(
              color: AppColors.cremaClaro,
              elevation: 0,
              child: ListTile(
                leading: Icon(
                  item.stockAgotado
                      ? Icons.remove_shopping_cart
                      : Icons.inventory,
                  color: item.stockAgotado
                      ? Colors.red
                      : AppColors.caramelo,
                ),
                title: Text(
                  item.nombreMostrar,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  'Disponible: ${item.cantidadConUnidad}',
                ),
                trailing: Text(
                  'Mín. ${item.cantidadMinima}',
                  style: const TextStyle(
                    color: AppColors.cafeMedio,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _TarjetaAlerta extends StatelessWidget {
  final String titulo;
  final int cantidad;
  final IconData icono;
  final bool agotado;

  const _TarjetaAlerta({
    required this.titulo,
    required this.cantidad,
    required this.icono,
    required this.agotado,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.cremaClaro,
      elevation: 0,
      child: ListTile(
        leading: Icon(
          icono,
          color: agotado ? Colors.red : AppColors.caramelo,
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            color: AppColors.textoCafe,
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Text(
          '$cantidad',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textoCafe,
          ),
        ),
      ),
    );
  }
}
