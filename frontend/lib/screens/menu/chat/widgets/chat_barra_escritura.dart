part of '../../chat_screen.dart';

mixin _ChatBarraEscritura
    on State<ChatScreen>, _ChatEstado, _ChatUtils, _ChatEnvio {
  Widget _buildBarraEscritura({
    required String pista,
    required String idioma,
  }) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          12,
          12,
          12,
        ),
        decoration: BoxDecoration(
          color: AppColors.cremaClaro,
          border: Border(
            top: BorderSide(
              color: AppColors.cremaOscuro,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: TextField(
                controller: _mensajeController,
                enabled: !_enviando,
                textCapitalization:
                    TextCapitalization.sentences,
                minLines: 1,
                maxLines: 4,
                onSubmitted: (_) => _enviarMensaje(),
                decoration: InputDecoration(
                  hintText: pista,
                  hintStyle: TextStyle(
                    color: AppColors.cafeMedio.withValues(
                      alpha: 0.7,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 13,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide(
                      color: AppColors.cremaOscuro,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide(
                      color: AppColors.cremaOscuro,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide(
                      color: AppColors.caramelo,
                      width: 1.5,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 9),
            SizedBox(
              width: 48,
              height: 48,
              child: IconButton(
                onPressed:
                    _enviando ? null : _enviarMensaje,
                style: IconButton.styleFrom(
                  backgroundColor: AppColors.cafeMedio,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor:
                      AppColors.cremaOscuro,
                  disabledForegroundColor:
                      AppColors.cafeMedio,
                  shape: const CircleBorder(),
                ),
                icon: Icon(
                  _enviando
                      ? Icons.hourglass_top_rounded
                      : Icons.send_rounded,
                ),
                tooltip: _texto(
                  idioma,
                  'Enviar mensaje',
                  'Send message',
                  'Enviar mensagem',
                  'Envoyer le message',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}