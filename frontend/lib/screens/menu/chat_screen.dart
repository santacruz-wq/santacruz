import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/api_config.dart';
import '../../core/config/app_colors.dart';
import '../../core/network/api_client.dart';
import '../../providers/language_provider.dart';

part 'chat/widgets/chat_estado.dart';
part 'chat/widgets/chat_utils.dart';
part 'chat/widgets/chat_envio.dart';
part 'chat/widgets/chat_appbar.dart';
part 'chat/widgets/chat_bienvenida.dart';
part 'chat/widgets/chat_lista.dart';
part 'chat/widgets/chat_barra_escritura.dart';
part 'chat/widgets/chat_burbuja.dart';
part 'chat/widgets/chat_indicador.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with
        _ChatEstado,
        _ChatUtils,
        _ChatEnvio,
        _ChatAppBar,
        _ChatBienvenida,
        _ChatLista,
        _ChatBarraEscritura {
  @override
  void dispose() {
    _mensajeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final idioma =
        context.watch<LanguageProvider>().idiomaCodigo;

    final titulo = 'Chat box';

    final bienvenida = _texto(
      idioma,
      '¡Hola! Bienvenido a Santa Cruz de la Plazuela. ¿En qué te puedo ayudar hoy?',
      'Hello! Welcome to Santa Cruz de la Plazuela. How can I help you today?',
      'Olá! Bem-vindo à Santa Cruz de la Plazuela. Como posso ajudar hoje?',
      'Bonjour ! Bienvenue à Santa Cruz de la Plazuela. Comment puis-je vous aider ?',
    );

    final pista = _texto(
      idioma,
      'Escribe tu mensaje...',
      'Write your message...',
      'Digite sua mensagem...',
      'Écrivez votre message...',
    );

    return Scaffold(
      backgroundColor: AppColors.crema,
      appBar: _buildAppBar(titulo),
      body: Container(
        decoration: BoxDecoration(
          color: AppColors.crema,
          image: const DecorationImage(
            image: AssetImage('assets/img/imagen_fondo.png'),
            fit: BoxFit.cover,
            opacity: 0.07,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: _mensajes.isEmpty
                  ? _buildBienvenida(
                      bienvenida: bienvenida,
                      titulo: titulo,
                    )
                  : _buildListaMensajes(),
            ),

            // Barra para escribir y enviar mensajes.
            _buildBarraEscritura(
              pista: pista,
              idioma: idioma,
            ),
          ],
        ),
      ),
    );
  }
}