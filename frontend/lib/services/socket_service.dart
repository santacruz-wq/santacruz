import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  static void conectar(
    String? usuarioId, {
    bool esCocina = false,
  }) {
    if (_socket != null && _socket!.connected) {
      return;
    }

    _socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    _socket!.connect();

    _socket!.onConnect((_) {
      print(
        'Socket conectado: ${_socket!.id}',
      );

      if (usuarioId != null) {
        _socket!.emit(
          'join',
          usuarioId,
        );

        print(
          'Usuario unido a sala: $usuarioId',
        );
      }

      if (usuarioId != null && !esCocina) {
        _socket!.emit(
          'joinMeseros',
        );

        print(
          'Mesero unido a sala: meseros',
        );
      }

      if (esCocina) {
        _socket!.emit(
          'joinCocina',
        );

        print(
          'Cocina unida a sala: cocina',
        );
      }
    });

    _socket!.onDisconnect((_) {
      print(
        'Socket desconectado',
      );
    });

    _socket!.onConnectError((error) {
      print(
        'Error Socket.IO: $error',
      );
    });
  }

  // ============================
  // 🔔 NUEVO PEDIDO
  // ============================

  static void escucharNuevoPedido(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'nuevoPedido',
      callback,
    );
  }

  static void dejarDeEscucharNuevoPedido(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'nuevoPedido',
      callback,
    );
  }

  // ============================
  // 🔔 PEDIDO EN COCINA
  // ============================

  static void escucharPedidoEnCocina(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'pedidoEnCocina',
      callback,
    );
  }

  static void dejarDeEscucharPedidoEnCocina(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'pedidoEnCocina',
      callback,
    );
  }

  // ============================
  // 🔔 PEDIDO LISTO
  // ============================

  static void escucharPedidoListo(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'pedidoListo',
      callback,
    );
  }

  static void dejarDeEscucharPedidoListo(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'pedidoListo',
      callback,
    );
  }

  // ============================
  // 🔔 NUEVA ADICIÓN
  // ============================

  static void escucharNuevaAdicion(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'nuevaAdicion',
      callback,
    );
  }

  static void dejarDeEscucharNuevaAdicion(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'nuevaAdicion',
      callback,
    );
  }

  // ============================
  // 🔔 PEDIDO SERVIDO
  // ============================

  static void escucharPedidoServido(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'pedidoServido',
      callback,
    );
  }

  static void dejarDeEscucharPedidoServido(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'pedidoServido',
      callback,
    );
  }

  // ============================
  // 🔔 PEDIDO PAGADO
  // ============================

  static void escucharPedidoPagado(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'pedidoPagado',
      callback,
    );
  }

  static void dejarDeEscucharPedidoPagado(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'pedidoPagado',
      callback,
    );
  }

  // ============================
  // 🔔 PEDIDO CANCELADO
  // ============================

  static void escucharPedidoCancelado(
    void Function(dynamic data) callback,
  ) {
    _socket?.on(
      'pedidoCancelado',
      callback,
    );
  }

  static void dejarDeEscucharPedidoCancelado(
    void Function(dynamic data) callback,
  ) {
    _socket?.off(
      'pedidoCancelado',
      callback,
    );
  }

  // ============================
  // 🔌 DESCONECTAR
  // ============================

  static void desconectar() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}