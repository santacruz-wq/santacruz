
import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class DashboardPedidos extends StatelessWidget {
  final int pendientes;
  final int cocina;
  final int listos;
  final int servidos;
  final int pagados;
  final int cancelados;

  const DashboardPedidos({
    super.key,
    required this.pendientes,
    required this.cocina,
    required this.listos,
    required this.servidos,
    required this.pagados,
    required this.cancelados,
  });

  @override
  Widget build(BuildContext context) {
    final estados = [
      ('Pendientes', pendientes, Icons.pending_actions),
      ('En cocina', cocina, Icons.soup_kitchen_outlined),
      ('Listos', listos, Icons.done),
      ('Servidos', servidos, Icons.room_service_outlined),
      ('Pagados', pagados, Icons.payments_outlined),
      ('Cancelados', cancelados, Icons.cancel_outlined),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estado de los pedidos',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textoCafe,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Todas las órdenes cargadas',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.cafeMedio,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: AppColors.cremaClaro,
          elevation: 0,
          child: Column(
            children: estados.map((estado) {
              return ListTile(
                dense: true,
                leading: Icon(
                  estado.$3,
                  color: AppColors.caramelo,
                ),
                title: Text(
                  estado.$1,
                  style: const TextStyle(
                    color: AppColors.textoCafe,
                  ),
                ),
                trailing: Text(
                  '${estado.$2}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textoCafe,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
