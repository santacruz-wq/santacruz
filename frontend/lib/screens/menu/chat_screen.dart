
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

    const titulo = 'Chat box';

    final bienvenida = _texto(
      idioma,
      '¡Hola! Bienvenido a Santa Cruz de la Plazuela. ¿En qué te puedo ayudar hoy?',
      'Hello! Welcome to Santa Cruz de la Plazuela. How can I help you today?',
      'Olá! Bem-vindo à Santa Cruz de la Plazuela. Como posso ajudar hoje?',
      'Bonjour ! Bienvenue à Santa Cruz de la Plazuela. Comment puis-je vous aider ?',
      de: 'Hallo! Willkommen bei Santa Cruz de la Plazuela. Wie kann ich dir heute helfen?',
      it: 'Ciao! Benvenuto a Santa Cruz de la Plazuela. Come posso aiutarti oggi?',
      zh: '你好！欢迎来到 Santa Cruz de la Plazuela。今天有什么可以帮您？',
      hi: 'नमस्ते! Santa Cruz de la Plazuela में आपका स्वागत है। मैं आपकी कैसे मदद कर सकता हूँ?',
      ar: 'مرحبًا بك في Santa Cruz de la Plazuela! كيف يمكنني مساعدتك اليوم؟',
      ru: 'Здравствуйте! Добро пожаловать в Santa Cruz de la Plazuela. Чем я могу помочь?',
      ja: 'こんにちは！Santa Cruz de la Plazuelaへようこそ。今日はどのようなお手伝いができますか？',
      ko: '안녕하세요! Santa Cruz de la Plazuela에 오신 것을 환영합니다. 무엇을 도와드릴까요?',
      id: 'Halo! Selamat datang di Santa Cruz de la Plazuela. Ada yang bisa saya bantu?',
      bn: 'হ্যালো! Santa Cruz de la Plazuela-এ স্বাগতম। আজ আমি কীভাবে সাহায্য করতে পারি?',
      tr: 'Merhaba! Santa Cruz de la Plazuela’ya hoş geldiniz. Size nasıl yardımcı olabilirim?',
    );

    final pista = _texto(
      idioma,
      'Escribe tu mensaje...',
      'Write your message...',
      'Digite sua mensagem...',
      'Écrivez votre message...',
      de: 'Schreibe deine Nachricht...',
      it: 'Scrivi il tuo messaggio...',
      zh: '请输入您的消息...',
      hi: 'अपना संदेश लिखें...',
      ar: 'اكتب رسالتك...',
      ru: 'Введите сообщение...',
      ja: 'メッセージを入力してください...',
      ko: '메시지를 입력하세요...',
      id: 'Tulis pesan Anda...',
      bn: 'আপনার বার্তা লিখুন...',
      tr: 'Mesajınızı yazın...',
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
