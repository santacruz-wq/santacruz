part of '../../chat_screen.dart';

mixin _ChatLista on State<ChatScreen>, _ChatEstado {
  Widget _buildListaMensajes() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(
        14,
        18,
        14,
        12,
      ),
      itemCount:
          _mensajes.length + (_enviando ? 1 : 0),
      itemBuilder: (context, index) {
        // Último elemento: indicador animado.
        if (_enviando &&
            index == _mensajes.length) {
          return const _IndicadorEscritura();
        }

        final mensaje = _mensajes[index];
        final rol = mensaje['rol'];
        final esUsuario = rol == 'usuario';
        final esError = rol == 'error';

        return _BurbujaMensaje(
          texto: mensaje['texto'] ?? '',
          esUsuario: esUsuario,
          esError: esError,
        );
      },
    );
  }
}