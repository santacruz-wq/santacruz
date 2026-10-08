import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';

/// Botón de filtro (fecha o mesa) con ícono y flecha.
class HistorialFiltroBoton extends StatelessWidget {
  final IconData icon;
  final String texto;
  final bool activo;
  final VoidCallback onTap;

  const HistorialFiltroBoton({
    super.key,
    required this.icon,
    required this.texto,
    required this.activo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.cremaClaro,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: activo
                  ? AppColors.caramelo
                  : AppColors.caramelo.withValues(
                      alpha: 0.25,
                    ),
              width: activo ? 1.4 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 19,
                color: activo
                    ? AppColors.caramelo
                    : AppColors.cafeMedio,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  texto,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: activo
                        ? AppColors.textoCafe
                        : AppColors.cafeMedio,
                    fontWeight: activo
                        ? FontWeight.w600
                        : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 20,
                color: AppColors.cafeMedio,
              ),
            ],
          ),
        ),
      ),
    );
  }
}