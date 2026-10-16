import 'package:flutter/material.dart';
import '../../../../core/config/app_colors.dart';

class DashboardEncabezado extends StatelessWidget {
  final bool cargando;
  final VoidCallback onActualizar;

  const DashboardEncabezado({
    super.key,
    required this.cargando,
    required this.onActualizar,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SANTA CRUZ',
                style: TextStyle(
                  fontSize: 12,
                  letterSpacing: 2,
                  color: AppColors.cafeMedio,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Panel de administración',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textoCafe,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Resumen de tu negocio',
                style: TextStyle(
                  color: AppColors.cafeMedio,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Actualizar datos',
          onPressed: cargando ? null : onActualizar,
          icon: const Icon(
            Icons.refresh,
            color: AppColors.textoCafe,
          ),
        ),
      ],
    );
  }
}
