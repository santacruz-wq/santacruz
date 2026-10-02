import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static IO.Socket? _socket;

  static void conectar(String usuarioId) {
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
      print('Socket conectado: ${_socket!.id}');

      _socket!.emit('join', usuarioId);

      print('Usuario unido a sala: $usuarioId');
    });

    _socket!.onDisconnect((_) {
      print('Socket desconectado');
    });

    _socket!.onConnectError((error) {
      print('Error Socket.IO: $error');
    });
  }

  static void escucharPedidoListo(
    void Function(dynamic data) callback,
  ) {
    _socket?.on('pedidoListo', callback);
  }

  static void desconectar() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }
}
