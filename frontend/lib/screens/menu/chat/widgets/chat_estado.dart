part of '../../chat_screen.dart';

mixin _ChatEstado on State<ChatScreen> {
  final TextEditingController _mensajeController =
      TextEditingController();

  final ScrollController _scrollController =
      ScrollController();

  final List<Map<String, String>> _mensajes = [];

  bool _enviando = false;
}