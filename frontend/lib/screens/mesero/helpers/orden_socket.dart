import '../../../services/socket_service.dart';

// ============================
// 🔔 ESCUCHAR CAMBIOS DE ORDEN
// ============================

void escucharEventosOrden(
  void Function(dynamic data) callback,
) {
  SocketService.escucharPedidoListo(callback);
  SocketService.escucharPedidoServido(callback);
  SocketService.escucharPedidoPagado(callback);
  SocketService.escucharPedidoCancelado(callback);
  SocketService.escucharNuevaAdicion(callback);
}

void dejarDeEscucharEventosOrden(
  void Function(dynamic data) callback,
) {
  SocketService.dejarDeEscucharPedidoListo(callback);
  SocketService.dejarDeEscucharPedidoServido(callback);
  SocketService.dejarDeEscucharPedidoPagado(callback);
  SocketService.dejarDeEscucharPedidoCancelado(callback);
  SocketService.dejarDeEscucharNuevaAdicion(callback);
}