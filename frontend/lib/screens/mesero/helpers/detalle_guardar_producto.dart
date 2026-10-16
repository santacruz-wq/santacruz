import '../../../models/orden_model.dart';
import '../../../models/product_model.dart';
import '../../../services/orden_service.dart';

/// Agrega un producto a la orden.
///
/// Si el pedido todavía está pendiente, usamos agregarProducto().
/// Si ya fue enviado a cocina, usamos crearAdicion() para que el
/// nuevo producto llegue nuevamente a cocina.
Future<void> guardarProductoEnOrden({
  required String ordenId,
  required ProductModel producto,
  required int cantidad,
  required String notasTexto,
}) async {
  final pedido = await OrdenService.getOrdenPorId(
    ordenId,
  );

  final orden = pedido['orden'] as OrdenModel;

  final notas = notasTexto.trim().isEmpty
      ? null
      : notasTexto.trim();

  if (orden.estaPendiente) {
    await OrdenService.agregarProducto(
      ordenId: ordenId,
      productoId: producto.id,
      cantidad: cantidad,
      notas: notas,
    );
  } else if (orden.estaEnCocina ||
      orden.estaListo ||
      orden.estaServido) {
    await OrdenService.crearAdicion(
      ordenId: ordenId,
      productos: [
        {
          'producto': producto.id,
          'cantidad': cantidad,
          'notas': notas,
        },
      ],
    );
  } else {
    throw Exception(
      'El pedido ya no permite agregar productos.',
    );
  }
}