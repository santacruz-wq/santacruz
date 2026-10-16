import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../helpers/historial_formato.dart';
import 'historial_filtro_boton.dart';

/// Fila de filtros (fecha y mesa) + botón "Limpiar filtros".
class HistorialFiltros extends StatelessWidget {
  final DateTime? fechaSeleccionada;
  final String? mesaSeleccionada;
  final bool filtrosActivos;
  final VoidCallback onSeleccionarFecha;
  final VoidCallback onSeleccionarMesa;
  final VoidCallback onLimpiar;

  const HistorialFiltros({
    super.key,
    required this.fechaSeleccionada,
    required this.mesaSeleccionada,
    required this.filtrosActivos,
    required this.onSeleccionarFecha,
    required this.onSeleccionarMesa,
    required this.onLimpiar,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // FILTROS
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: HistorialFiltroBoton(
                  icon: Icons.calendar_today_rounded,
                  texto: fechaSeleccionada == null
                      ? 'Todas las fechas'
                      : fechaCorta(fechaSeleccionada!),
                  activo: fechaSeleccionada != null,
                  onTap: onSeleccionarFecha,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: HistorialFiltroBoton(
                  icon: Icons.table_restaurant_rounded,
                  texto:
                      mesaSeleccionada ?? 'Todas las mesas',
                  activo: mesaSeleccionada != null,
                  onTap: onSeleccionarMesa,
                ),
              ),
            ],
          ),
        ),

        // LIMPIAR FILTROS
        if (filtrosActivos)
          Padding(
            padding: const EdgeInsets.fromLTRB(
              16,
              8,
              16,
              4,
            ),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: onLimpiar,
                icon: Icon(
                  Icons.filter_alt_off,
                  size: 18,
                  color: AppColors.caramelo,
                ),
                label: Text(
                  'Limpiar filtros',
                  style: TextStyle(
                    color: AppColors.caramelo,
                  ),
                ),
              ),
            ),
          )
        else
          const SizedBox(height: 8),
      ],
    );
  }
}