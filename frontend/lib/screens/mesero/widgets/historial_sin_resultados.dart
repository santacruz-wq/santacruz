import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

class HistorialSinResultados extends StatelessWidget {
  final bool filtrosActivos;
  final Future<void> Function() onRefresh;

  const HistorialSinResultados({
    super.key,
    required this.filtrosActivos,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.caramelo,
      onRefresh: onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          const SizedBox(height: 100),
          Icon(
            filtrosActivos
                ? Icons.search_off_rounded
                : Icons.history_rounded,
            size: 65,
            color: AppColors.cafeMedio,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              filtrosActivos
                  ? 'No se encontraron pedidos'
                  : 'No hay pedidos en el historial',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textoCafe,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 35,
            ),
            child: Text(
              filtrosActivos
                  ? 'Prueba cambiando los filtros o la búsqueda.'
                  : 'Cuando se paguen o cancelen pedidos aparecerán aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.cafeMedio,
              ),
            ),
          ),
        ],
      ),
    );
  }
}