import 'package:flutter/material.dart';
import '../../models/mesa_model.dart';

class MesaCard extends StatelessWidget {
  final MesaModel mesa;
  final VoidCallback onTap;

  const MesaCard({super.key, required this.mesa, required this.onTap});

  // COLOR SEGUN EL ESTADO DE LA MESA
  Color get _color {
    if (mesa.estaOcupada) return Colors.red.shade600;
    if (mesa.estaReservada) return Colors.orange.shade700;
    return Colors.green.shade600;
  }

  // TEXTO DEL ESTADO
  String get _textoEstado {
    if (mesa.estaOcupada) return 'Ocupada';
    if (mesa.estaReservada) return 'Reservada';
    return 'Libre';
  }

  // ICONO SEGUN EL ESTADO
  IconData get _icono {
    if (mesa.estaOcupada) return Icons.restaurant;
    if (mesa.estaReservada) return Icons.event_seat;
    return Icons.table_restaurant;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _color, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_icono, size: 38, color: _color),
            const SizedBox(height: 8),
            Text(
              mesa.nombre,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              '${mesa.capacidad} personas',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _color.withAlpha(30),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _textoEstado,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _color,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}