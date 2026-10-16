import 'package:flutter/material.dart';

import '../../../models/mesa_model.dart';
import '../../../models/orden_model.dart';
import '../../../services/orden_service.dart';
import '../crear_orden_screen.dart';
import '../orden_screen.dart';

// ============================
// 🪑 ACCIÓN AL TOCAR UNA MESA
// ============================

Future<void> onMesaTap(
  BuildContext context,
  MesaModel mesa,
) async {
  // MESA LIBRE
  if (mesa.estaLibre) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CrearOrdenScreen(
          mesa: mesa,
        ),
      ),
    );

    return;
  }

  // MESA OCUPADA
  if (mesa.estaOcupada) {
    try {
      final ordenes = await OrdenService.getOrdenes();

      if (!context.mounted) return;

      final ordenesMesa = ordenes
          .where(
            (orden) =>
                orden.mesaId == mesa.id &&
                orden.estado != 'pagado' &&
                orden.estado != 'cancelado',
          )
          .toList();

      if (ordenesMesa.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'No se encontró una orden activa para esta mesa.',
            ),
          ),
        );

        return;
      }

      final OrdenModel orden = ordenesMesa.first;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrdenScreen(
            ordenId: orden.id,
          ),
        ),
      );
    } catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceFirst(
                  'Exception: ',
                  '',
                ),
          ),
        ),
      );
    }

    return;
  }

  // MESA RESERVADA U OTRO ESTADO
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        '${mesa.nombre} está ${mesa.estado}.',
      ),
    ),
  );
}