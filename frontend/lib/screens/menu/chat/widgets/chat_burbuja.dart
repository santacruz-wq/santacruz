part of '../../chat_screen.dart';

// Burbuja reutilizable para cada mensaje.
class _BurbujaMensaje extends StatelessWidget {
  final String texto;
  final bool esUsuario;
  final bool esError;

  const _BurbujaMensaje({
    required this.texto,
    required this.esUsuario,
    required this.esError,
  });

  @override
  Widget build(BuildContext context) {
    final colorBurbuja = esError
        ? Colors.red.shade50
        : esUsuario
            ? AppColors.cafeMedio
            : AppColors.cremaClaro;

    final colorTexto = esUsuario && !esError
        ? Colors.white
        : AppColors.textoCafe;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment: esUsuario
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!esUsuario) ...[
            Container(
              width: 30,
              height: 30,
              margin: const EdgeInsets.only(right: 7),
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.cremaOscuro,
                ),
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.local_cafe_rounded,
                    size: 19,
                    color: AppColors.cafeMedio,
                  ),
                ),
              ),
            ),
          ],
          Flexible(
            child: Container(
              constraints: BoxConstraints(
                maxWidth:
                    MediaQuery.of(context).size.width * 0.76,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: colorBurbuja,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(19),
                  topRight: const Radius.circular(19),
                  bottomLeft: Radius.circular(esUsuario ? 19 : 5),
                  bottomRight: Radius.circular(esUsuario ? 5 : 19),
                ),
                border: esError
                    ? Border.all(color: Colors.red.shade300)
                    : esUsuario
                        ? null
                        : Border.all(
                            color: AppColors.cremaOscuro,
                          ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.035),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                texto,
                style: TextStyle(
                  color: colorTexto,
                  fontSize: 15,
                  height: 1.45,
                ),
              ),
            ),
          ),
          if (esUsuario)
            const SizedBox(width: 2),
        ],
      ),
    );
  }
}