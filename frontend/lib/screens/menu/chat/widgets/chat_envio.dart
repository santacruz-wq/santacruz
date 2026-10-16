part of '../../chat_screen.dart';

mixin _ChatEnvio on State<ChatScreen>, _ChatEstado, _ChatUtils {
  Future<void> _enviarMensaje() async {
    final texto = _mensajeController.text.trim();

    if (texto.isEmpty || _enviando) return;

    final idioma =
        context.read<LanguageProvider>().idiomaCodigo;

    setState(() {
      _agregarMensaje('usuario', texto);
      _mensajeController.clear();
      _enviando = true;
    });

    _desplazarAbajo();

    try {
      final response = await ApiClient.post(
        ApiConfig.chat,
        {
          'mensaje': texto,
          'idioma': idioma,
        },
        auth: false,
      ).timeout(const Duration(seconds: 45));

      if (!mounted) return;

      final Map<String, dynamic> data =
          jsonDecode(response.body);

      if (response.statusCode == 200) {
        final respuesta = data['respuesta']?.toString();

        setState(() {
          _agregarMensaje(
            'barista',
            respuesta?.isNotEmpty == true
                ? respuesta!
                : _texto(
                    idioma,
                    'No pude generar una respuesta.',
                    'I could not generate a response.',
                    'Não consegui gerar uma resposta.',
                    'Je n’ai pas pu générer de réponse.',
                  ),
          );
        });
      } else {
        setState(() {
          _agregarMensaje(
            'error',
            _texto(
              idioma,
              'No pude procesar tu mensaje. Intenta nuevamente.',
              'I could not process your message. Please try again.',
              'Não consegui processar sua mensagem. Tente novamente.',
              'Je n’ai pas pu traiter votre message. Réessayez.',
            ),
          );
        });
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _agregarMensaje(
          'error',
          _texto(
            idioma,
            'No se pudo conectar con el chat. Verifica tu conexión e inténtalo de nuevo.',
            'Could not connect to the chat. Check your connection and try again.',
            'Não foi possível conectar ao chat. Verifique sua conexão e tente novamente.',
            'Impossible de joindre le chat. Vérifiez votre connexion et réessayez.',
          ),
        );
      });
    } finally {
      if (mounted) {
        setState(() {
          _enviando = false;
        });

        _desplazarAbajo();
      }
    }
  }
}