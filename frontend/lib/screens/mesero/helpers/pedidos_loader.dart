import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../../../services/orden_service.dart';

/// Trae las órdenes activas (no pagadas ni canceladas) con sus detalles.
Future<List<Map<String, dynamic>>> cargarPedidosActivos() async {
  final ordenes = await OrdenService.getOrdenes();

  final pedidosActivos = <Map<String, dynamic>>[];

  for (final orden in ordenes) {
    if (orden.estaPagado || orden.estaCancelado) {
      continue;
    }

    final data = await OrdenService.getOrdenPorId(orden.id);

    pedidosActivos.add({
      'orden': data['orden'] as OrdenModel,
      'detalles': data['detalles'] as List<OrdenDetalleModel>,
    });
  }

  return pedidosActivos;
}