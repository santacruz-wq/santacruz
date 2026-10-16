
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';
import '../../../../models/inventario_model.dart';
import '../../../../services/inventario_service.dart';

class HistorialMovimientosDialog extends StatelessWidget {
  final InventarioModel item;

  const HistorialMovimientosDialog({
    super.key,
    required this.item,
  });

  String _cantidad(dynamic valor) {
    final n = valor is num
        ? valor.toDouble()
        : double.tryParse('$valor') ?? 0;
    return n == n.roundToDouble() ? n.toInt().toString() : n.toString();
  }

  String _fecha(dynamic valor) {
    final fecha = DateTime.tryParse('$valor');
    if (fecha == null) return 'Fecha no disponible';

    final f = fecha.toLocal();
    final d = f.day.toString().padLeft(2, '0');
    final m = f.month.toString().padLeft(2, '0');
    final h = f.hour.toString().padLeft(2, '0');
    final min = f.minute.toString().padLeft(2, '0');
    return '$d/$m/${f.year} - $h:$min';
  }

  String _usuario(dynamic usuario) {
    if (usuario is Map && usuario['nombre'] != null) {
      return usuario['nombre'].toString();
    }
    return 'Usuario no disponible';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.cremaClaro,
      title: Text(
        'Historial: ${item.nombreMostrar}',
        style: const TextStyle(
          color: AppColors.textoCafe,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      content: SizedBox(
        width: 450,
        child: FutureBuilder<List<dynamic>>(
          future: InventarioService.getMovimientosPorInventario(item.id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 140,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.caramelo,
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return SizedBox(
                height: 140,
                child: Center(
                  child: Text(
                    'No se pudo cargar el historial.\n${snapshot.error}',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            final lista = snapshot.data ?? [];
            if (lista.isEmpty) {
              return const SizedBox(
                height: 140,
                child: Center(
                  child: Text('Todavía no hay movimientos registrados.'),
                ),
              );
            }

            return SizedBox(
              height: 380,
              child: ListView.separated(
                itemCount: lista.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final m = lista[index];
                  final entrada = m['tipo'] == 'entrada';
                  final color = entrada ? Colors.green : Colors.red;
                  final signo = entrada ? '+' : '-';
                  final motivo = (m['motivo'] ?? '').toString().trim();

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              entrada
                                  ? Icons.arrow_downward
                                  : Icons.arrow_upward,
                              color: color,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                entrada ? 'Entrada de stock' : 'Salida de stock',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '$signo${_cantidad(m['cantidad'])} '
                              '${item.unidadMedida}',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _fecha(m['createdAt']),
                          style: const TextStyle(
                            color: AppColors.cafeMedio,
                            fontSize: 12,
                          ),
                        ),
                        Text('Registrado por: ${_usuario(m['usuario'])}'),
                        if (motivo.isNotEmpty) Text('Motivo: $motivo'),
                      ],
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
