
part of '../../chat_screen.dart';

mixin _ChatUtils on State<ChatScreen>, _ChatEstado {
  String _texto(
    String codigo,
    String es,
    String en,
    String pt,
    String fr, {
    String de = 'Willkommen! Wie kann ich dir helfen?',
    String it = 'Benvenuto! Come posso aiutarti?',
    String zh = '你好！欢迎来到 Santa Cruz de la Plazuela。今天有什么可以帮您？',
    String hi = 'नमस्ते! Santa Cruz de la Plazuela में आपका स्वागत है। मैं आपकी कैसे मदद कर सकता हूँ?',
    String ar = 'مرحبًا بك في Santa Cruz de la Plazuela! كيف يمكنني مساعدتك اليوم؟',
    String ru = 'Здравствуйте! Добро пожаловать в Santa Cruz de la Plazuela. Чем я могу помочь?',
    String ja = 'こんにちは！Santa Cruz de la Plazuelaへようこそ。今日はどのようなお手伝いができますか？',
    String ko = '안녕하세요! Santa Cruz de la Plazuela에 오신 것을 환영합니다. 무엇을 도와드릴까요?',
    String id = 'Halo! Selamat datang di Santa Cruz de la Plazuela. Ada yang bisa saya bantu?',
    String bn = 'হ্যালো! Santa Cruz de la Plazuela-এ স্বাগতম। আজ আমি কীভাবে সাহায্য করতে পারি?',
    String tr = 'Merhaba! Santa Cruz de la Plazuela’ya hoş geldiniz. Size nasıl yardımcı olabilirim?',
  }) {
    switch (codigo.toLowerCase().split('-').first) {
      case 'en':
        return en;
      case 'pt':
        return pt;
      case 'fr':
        return fr;
      case 'de':
        return de;
      case 'it':
        return it;
      case 'zh':
        return zh;
      case 'hi':
        return hi;
      case 'ar':
        return ar;
      case 'ru':
        return ru;
      case 'ja':
        return ja;
      case 'ko':
        return ko;
      case 'id':
        return id;
      case 'bn':
        return bn;
      case 'tr':
        return tr;
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
