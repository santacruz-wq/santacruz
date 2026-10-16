part of '../../chat_screen.dart';

mixin _ChatUtils on State<ChatScreen>, _ChatEstado {
  String _texto(
    String codigo,
    String es,
    String en,
    String pt,
    String fr,
  ) {
    switch (codigo) {
      case 'en':
        return en;
      case 'pt':
        return pt;
      case 'fr':
        return fr;
      default:
        return es;
    }
  }

  void _agregarMensaje(String rol, String texto) {
    _mensajes.add({
      'rol': rol,
      'texto': texto,
    });
  }

  void _desplazarAbajo() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}