
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../utils/pedidos_formatters.dart';

class PedidosFiltros extends StatelessWidget {
  final TextEditingController busquedaController;
  final String busqueda;
  final String filtroFecha;
  final String filtroEstado;
  final DateTime? fechaElegida;
  final List<String> estados;
  final ValueChanged<String> onBusqueda;
  final VoidCallback onLimpiarBusqueda;
  final ValueChanged<String> onCambiarFecha;
  final ValueChanged<String> onCambiarEstado;
  final VoidCallback onElegirFecha;

  const PedidosFiltros({
    super.key,
    required this.busquedaController,
    required this.busqueda,
    required this.filtroFecha,
    required this.filtroEstado,
    required this.fechaElegida,
    required this.estados,
    required this.onBusqueda,
    required this.onLimpiarBusqueda,
    required this.onCambiarFecha,
    required this.onCambiarEstado,
    required this.onElegirFecha,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: TextField(
            controller: busquedaController,
            onChanged: onBusqueda,
            decoration: InputDecoration(
              hintText: 'Buscar por mesa, mesero o ID...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: busqueda.isEmpty
                  ? null
                  : IconButton(
                      tooltip: 'Limpiar búsqueda',
                      onPressed: onLimpiarBusqueda,
                      icon: const Icon(Icons.close),
                    ),
              filled: true,
              fillColor: AppColors.cremaClaro,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 44,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              _chipFecha('Todos', 'todos'),
              const SizedBox(width: 8),
              _chipFecha('Hoy', 'hoy'),
              const SizedBox(width: 8),
              _chipFecha('Ayer', 'ayer'),
              const SizedBox(width: 8),
              ActionChip(
                avatar: const Icon(
                  Icons.calendar_month,
                  size: 18,
                  color: AppColors.textoCafe,
                ),
                label: Text(
                  filtroFecha == 'elegida' && fechaElegida != null
                      ? '${fechaElegida!.day.toString().padLeft(2, '0')}/'
                          '${fechaElegida!.month.toString().padLeft(2, '0')}/'
                          '${fechaElegida!.year}'
                      : 'Elegir fecha',
                ),
                backgroundColor: filtroFecha == 'elegida'
                    ? AppColors.carameloClaro
                    : AppColors.cremaClaro,
                onPressed: onElegirFecha,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 44,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: estados.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (_, index) {
              final estado = estados[index];
              final seleccionado = filtroEstado == estado;

              return ChoiceChip(
                label: Text(PedidosFormatters.nombreEstado(estado)),
                selected: seleccionado,
                onSelected: (_) => onCambiarEstado(estado),
                selectedColor: AppColors.carameloClaro,
                backgroundColor: AppColors.cremaClaro,
                labelStyle: TextStyle(
                  color: AppColors.textoCafe,
                  fontWeight: seleccionado
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
                side: BorderSide(
                  color: seleccionado
                      ? AppColors.caramelo
                      : AppColors.cremaOscuro,
                ),
                showCheckmark: false,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _chipFecha(String etiqueta, String valor) {
    final seleccionado = filtroFecha == valor;

    return ChoiceChip(
      label: Text(etiqueta),
      selected: seleccionado,
      onSelected: (_) => onCambiarFecha(valor),
      selectedColor: AppColors.carameloClaro,
      backgroundColor: AppColors.cremaClaro,
      labelStyle: TextStyle(
        color: AppColors.textoCafe,
        fontWeight:
            seleccionado ? FontWeight.bold : FontWeight.normal,
      ),
      side: BorderSide(
        color: seleccionado
            ? AppColors.caramelo
            : AppColors.cremaOscuro,
      ),
      showCheckmark: false,
    );
  }
}
