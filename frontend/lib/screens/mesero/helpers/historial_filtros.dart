import 'package:flutter/material.dart';

import '../../../core/config/app_colors.dart';
import '../../../models/orden_model.dart';
import '../../../services/orden_service.dart';

/// Trae las órdenes pagadas o canceladas, de la más nueva a la más vieja.
Future<List<OrdenModel>> cargarHistorialPedidos() async {
  final ordenes = await OrdenService.getOrdenes();

  final historial = ordenes.where((orden) {
    return orden.estaPagado || orden.estaCancelado;
  }).toList();

  historial.sort((a, b) {
    final fechaA =
        a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    final fechaB =
        b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);

    return fechaB.compareTo(fechaA);
  });

  return historial;
}

/// Nombres de mesa sin repetir y ordenados.
List<String> mesasDePedidos(List<OrdenModel> pedidos) {
  final mesas = pedidos
      .map(
        (orden) => orden.mesaNombre.trim(),
      )
      .where(
        (mesa) => mesa.isNotEmpty,
      )
      .toSet()
      .toList();

  mesas.sort();

  return mesas;
}

/// Aplica búsqueda, filtro de mesa y filtro de fecha.
List<OrdenModel> filtrarPedidos(
  List<OrdenModel> pedidos, {
  required String busqueda,
  required String? mesaSeleccionada,
  required DateTime? fechaSeleccionada,
}) {
  final texto = busqueda.trim().toLowerCase();

  return pedidos.where((orden) {
    // Buscar por mesa o mesero.
    if (texto.isNotEmpty) {
      final mesa = orden.mesaNombre.toLowerCase();

      final mesero = orden.meseroNombre.toLowerCase();

      if (!mesa.contains(texto) && !mesero.contains(texto)) {
        return false;
      }
    }

    // Filtrar por mesa.
    if (mesaSeleccionada != null &&
        orden.mesaNombre != mesaSeleccionada) {
      return false;
    }

    // Filtrar por fecha.
    if (fechaSeleccionada != null) {
      final fechaOrden = orden.createdAt?.toLocal();

      if (fechaOrden == null) {
        return false;
      }

      if (!DateUtils.isSameDay(
        fechaOrden,
        fechaSeleccionada,
      )) {
        return false;
      }
    }

    return true;
  }).toList();
}

/// Abre el selector de fecha con los colores de la app.
Future<DateTime?> seleccionarFechaHistorial(
  BuildContext context,
  DateTime? fechaInicial,
) {
  final ahora = DateTime.now();

  return showDatePicker(
    context: context,
    initialDate: fechaInicial ?? ahora,
    firstDate: DateTime(2020),
    lastDate: DateTime(
      ahora.year,
      ahora.month,
      ahora.day,
    ),
    builder: (context, child) {
      return Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: AppColors.caramelo,
            onPrimary: Colors.white,
            surface: AppColors.cremaClaro,
            onSurface: AppColors.textoCafe,
          ),
        ),
        child: child!,
      );
    },
  );
}