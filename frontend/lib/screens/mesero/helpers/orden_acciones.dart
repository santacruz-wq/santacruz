import 'package:flutter/material.dart';

import '../../../models/orden_model.dart';
import '../../../services/orden_service.dart';

// ============================
// ➕ AGREGAR PRODUCTOS
// ============================

Future<void> agregarProductosAOrden(
  BuildContext context,
  String ordenId,
  List<Map<String, dynamic>> productos,
  Future<void> Function() onRecargar,
) async {
  try {
    final ordenData = await OrdenService.getOrdenPorId(
      ordenId,
    );

    final orden = ordenData['orden'] as OrdenModel;

    // SI TODAVÍA ESTÁ PENDIENTE,
    // LOS PRODUCTOS PERTENECEN AL PEDIDO ORIGINAL.

    if (orden.estaPendiente) {
      for (final item in productos) {
        await OrdenService.agregarProducto(
          ordenId: ordenId,
          productoId: item['producto'],
          cantidad: item['cantidad'],
          notas: item['notas'],
        );
      }

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Productos agregados correctamente.',
          ),
        ),
      );
    } else {
      // SI YA FUE ENVIADA A COCINA,
      // CREAMOS UNA NUEVA ADICIÓN.

      await OrdenService.crearAdicion(
        ordenId: ordenId,
        productos: productos,
      );

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Nueva adición creada correctamente.',
          ),
        ),
      );
    }

    await onRecargar();
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
}