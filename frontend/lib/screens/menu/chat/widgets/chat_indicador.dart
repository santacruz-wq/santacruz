part of '../../chat_screen.dart';

// Indicador animado de tres puntos.
class _IndicadorEscritura extends StatefulWidget {
  const _IndicadorEscritura();

  @override
  State<_IndicadorEscritura> createState() =>
      _IndicadorEscrituraState();
}

class _IndicadorEscrituraState
    extends State<_IndicadorEscritura>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controlador;

  @override
  void initState() {
    super.initState();

    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 17,
              vertical: 14,
            ),
            decoration: BoxDecoration(
              color: AppColors.cremaClaro,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(19),
                topRight: Radius.circular(19),
                bottomLeft: Radius.circular(5),
                bottomRight: Radius.circular(19),
              ),
              border: Border.all(
                color: AppColors.cremaOscuro,
              ),
            ),
            child: AnimatedBuilder(
              animation: _controlador,
              builder: (context, child) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    final progreso =
                        (_controlador.value * 3 - index).clamp(
                      0.0,
                      1.0,
                    );

                    final opacidad =
                        0.35 + (0.65 * progreso);

                    return Container(
                      width: 7,
                      height: 7,
                      margin: EdgeInsets.only(
                        right: index == 2 ? 0 : 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cafeMedio.withValues(
                          alpha: opacidad,
                        ),
                        shape: BoxShape.circle,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}