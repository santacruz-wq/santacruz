import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/mesa_model.dart';

class TarjetaMesa extends StatelessWidget {
  final MesaModel mesa;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const TarjetaMesa({
    super.key,
    required this.mesa,
    required this.onEditar,
    required this.onEliminar,
  });

  Color get _colorEstado {
    if (mesa.estaOcupada) return Colors.red.shade700;
    if (mesa.estaReservada) return Colors.orange.shade800;
    return Colors.green.shade700;
  }

  String get _textoEstado {
    if (mesa.estaOcupada) return 'Ocupada';
    if (mesa.estaReservada) return 'Reservada';
    return 'Libre';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.tarjeta,
      elevation: 1,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: AppColors.caramelo.withValues(alpha: 0.15),
          child: const Icon(
            Icons.table_restaurant_outlined,
            color: AppColors.caramelo,
          ),
        ),
        title: Text(
          mesa.nombre,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textoCafe,
          ),
        ),
        subtitle: Text(
          'Capacidad: ${mesa.capacidad} ${mesa.capacidad == 1 ? 'persona' : 'personas'}',
          style: const TextStyle(color: AppColors.cafeMedio),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: _colorEstado.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _textoEstado,
                style: TextStyle(
                  color: _colorEstado,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.cafeMedio),
              onSelected: (valor) {
                if (valor == 'editar') {
                  onEditar();
                } else {
                  onEliminar();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'editar', child: Text('Editar')),
                PopupMenuItem(value: 'eliminar', child: Text('Eliminar')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}