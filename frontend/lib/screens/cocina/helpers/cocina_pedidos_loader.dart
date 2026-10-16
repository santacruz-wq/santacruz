import '../../../models/orden_model.dart';
import '../../../models/orden_detalle_model.dart';
import '../../../services/orden_service.dart';

/// Trae las órdenes en cocina junto con sus detalles.
Future<List<Map<String, dynamic>>> cargarPedidosEnCocina() async {
  final ordenes = await OrdenService.getOrdenes();

  final List<Map<String, dynamic>> pedidos = [];

  for (final orden in ordenes) {
    if (orden.estado != 'en_cocina') {
      continue;
    }

    final data = await OrdenService.getOrdenPorId(
      orden.id,
    );

    pedidos.add({
      'orden': data['orden'] as OrdenModel,
      'detalles':
          data['detalles'] as List<OrdenDetalleModel>,
    });
  }

  return pedidos;
}