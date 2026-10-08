import '../../../services/socket_service.dart';

// ============================
// 🔔 EVENTOS DE SOCKET.IO
// ============================

/// Empieza a escuchar todos los eventos que cambian el estado de una orden.
void escucharEventosMesas(
  void Function(dynamic data) callback,
) {
  SocketService.escucharNuevoPedido(callback);
  SocketService.escucharPedidoListo(callback);
  SocketService.escucharPedidoServido(callback);
  SocketService.escucharPedidoPagado(callback);
  SocketService.escucharPedidoCancelado(callback);
  SocketService.escucharNuevaAdicion(callback);
}

/// Deja de escuchar los mismos eventos (se usa en dispose).
void dejarDeEscucharEventosMesas(
  void Function(dynamic data) callback,
) {
  SocketService.dejarDeEscucharNuevoPedido(callback);
  SocketService.dejarDeEscucharPedidoListo(callback);
  SocketService.dejarDeEscucharPedidoServido(callback);
  SocketService.dejarDeEscucharPedidoPagado(callback);
  SocketService.dejarDeEscucharPedidoCancelado(callback);
  SocketService.dejarDeEscucharNuevaAdicion(callback);
}