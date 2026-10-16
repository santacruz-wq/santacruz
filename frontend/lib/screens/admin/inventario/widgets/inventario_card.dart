
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/inventario_model.dart';
import 'dato_stock.dart';

class InventarioCard extends StatelessWidget {
  final InventarioModel item;
  final Color colorEstado;
  final String textoEstado;
  final IconData iconoEstado;
  final VoidCallback onVerHistorial;
  final VoidCallback onEditarLimites;

  const InventarioCard({
    super.key,
    required this.item,
    required this.colorEstado,
    required this.textoEstado,
    required this.iconoEstado,
    required this.onVerHistorial,
    required this.onEditarLimites,
  });

  String _cantidad(double n) =>
      n == n.roundToDouble() ? n.toInt().toString() : n.toString();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: AppColors.crema,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: AppColors.cremaOscuro,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    item.esInsumo
                        ? Icons.kitchen_outlined
                        : Icons.inventory_2_outlined,
                    color: AppColors.cafeMedio,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.nombreMostrar,
                        style: const TextStyle(
                          color: AppColors.textoCafe,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        item.esInsumo ? 'Insumo' : 'Producto del menú',
                        style: const TextStyle(
                          color: AppColors.cafeMedio,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(iconoEstado, color: colorEstado),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: DatoStock(
                    titulo: 'Disponible',
                    valor: _cantidad(item.cantidadDisponible),
                    unidad: item.unidadMedida,
                  ),
                ),
                Expanded(
                  child: DatoStock(
                    titulo: 'Mínimo',
                    valor: _cantidad(item.cantidadMinima),
                    unidad: item.unidadMedida,
                  ),
                ),
                Expanded(
                  child: DatoStock(
                    titulo: 'Máximo',
                    valor: _cantidad(item.cantidadMaxima),
                    unidad: item.unidadMedida,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: colorEstado.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(iconoEstado, color: colorEstado, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    textoEstado,
                    style: TextStyle(
                      color: colorEstado,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              children: [
                TextButton.icon(
                  onPressed: onEditarLimites,
                  icon: const Icon(Icons.tune),
                  label: const Text('Editar límites'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.caramelo,
                  ),
                ),
                TextButton.icon(
                  onPressed: onVerHistorial,
                  icon: const Icon(Icons.history),
                  label: const Text('Ver historial'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.cafeMedio,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
