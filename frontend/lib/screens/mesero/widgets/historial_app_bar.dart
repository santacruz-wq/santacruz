import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

/// AppBar de "Historial de pedidos" con botón de actualizar.
class HistorialAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final VoidCallback onRecargar;

  const HistorialAppBar({
    super.key,
    required this.onRecargar,
  });

  @override
  Size get preferredSize =>
      const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.crema,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'Historial de pedidos',
        style: TextStyle(
          color: AppColors.textoCafe,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        IconButton(
          onPressed: onRecargar,
          icon: Icon(
            Icons.refresh,
            color: AppColors.cafeMedio,
          ),
          tooltip: 'Actualizar',
        ),
      ],
    );
  }
}