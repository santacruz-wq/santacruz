
import 'package:flutter/material.dart';

class OfertaCard extends StatelessWidget {
  final Map<String, dynamic> oferta;
  final bool es;
  final bool favorito;
  final bool esOscuro;

  final Color superficie;
  final Color textoPrincipal;
  final Color textoSecundario;

  final String textoAgregar;

  final VoidCallback onFavorito;
  final VoidCallback onAgregar;

  const OfertaCard({
    super.key,
    required this.oferta,
    required this.es,
    required this.favorito,
    required this.esOscuro,
    required this.superficie,
    required this.textoPrincipal,
    required this.textoSecundario,
    required this.textoAgregar,
    required this.onFavorito,
    required this.onAgregar,
  });

  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color dorado = Color(0xFFD4A017);
  static const Color doradoClaro = Color(0xFFF3D27A);
  static const Color crema = Color(0xFFF7F1E8);

  @override
  Widget build(BuildContext context) {
    final String nombre =
        es ? oferta['nombre'] : oferta['nombreEn'];

    final String descripcion =
        es ? oferta['descripcion'] : oferta['descripcionEn'];

    return Container(
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: doradoClaro.withValues(alpha: 0.70),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: esOscuro ? 0.22 : 0.08,
            ),
            blurRadius: 14,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // PARTE SUPERIOR
          // ============================================================
          SizedBox(
            height: 150,
            child: Stack(
              children: [
                // FONDO
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: esOscuro
                          ? [
                              const Color(0xFF3E2723),
                              const Color(0xFF5D4037),
                            ]
                          : [
                              const Color(0xFFFFF3D6),
                              const Color(0xFFF7E5BC),
                            ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),

                // DECORACIÓN SUAVE
                Positioned(
                  right: -25,
                  bottom: -30,
                  child: Container(
                    width: 105,
                    height: 105,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: doradoClaro.withValues(
                        alpha: esOscuro ? 0.08 : 0.18,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  left: -35,
                  top: -35,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(
                        alpha: esOscuro ? 0.03 : 0.20,
                      ),
                    ),
                  ),
                ),

                // ======================================================
                // ICONO DEL PRODUCTO
                // ======================================================
                Center(
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: esOscuro
                          ? cafeOscuro.withValues(alpha: 0.80)
                          : crema.withValues(alpha: 0.95),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: esOscuro ? 0.20 : 0.10,
                          ),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      oferta['icono'],
                      size: 52,
                      color: esOscuro ? doradoClaro : cafe,
                    ),
                  ),
                ),

                // ======================================================
                // DESCUENTO
                // ======================================================
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: dorado,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.18),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.local_offer_outlined,
                          color: Colors.white,
                          size: 14,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          oferta['descuento'],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // FAVORITO
                // ======================================================
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: superficie,
                    shape: const CircleBorder(),
                    elevation: 2,
                    child: InkWell(
                      onTap: onFavorito,
                      customBorder: const CircleBorder(),
                      child: SizedBox(
                        width: 42,
                        height: 42,
                        child: Icon(
                          favorito
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: favorito
                              ? Colors.red
                              : textoSecundario,
                          size: 21,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ============================================================
          // INFORMACIÓN
          // ============================================================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                13,
                13,
                13,
                12,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ======================================================
                  // NOMBRE
                  // ======================================================
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 15,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ======================================================
                  // PRECIOS
                  // ======================================================
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        oferta['precioAnterior'],
                        style: TextStyle(
                          color: textoSecundario.withValues(
                            alpha: 0.65,
                          ),
                          fontSize: 12,
                          decoration: TextDecoration.lineThrough,
                          decorationThickness: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          oferta['precio'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: dorado,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                   // ======================================================
// AHORRO
// ======================================================
Row(
  children: [
    Icon(
      Icons.savings_outlined,
      color: dorado,
      size: 15,
    ),
    const SizedBox(width: 4),
    Text(
      es
          ? 'Ahorras ${oferta['ahorro']}'
          : 'You save ${oferta['ahorro']}',
      style: const TextStyle(
        color: dorado,
        fontSize: 11,
        fontWeight: FontWeight.w700,
      ),
    ),
  ],
),

const SizedBox(height: 6),

                  // ======================================================
                  // DESCRIPCIÓN
                  // ======================================================
                  Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 11,
                      height: 1.35,
                    ),
                  ),

                  const Spacer(),

                  // ======================================================
                  // BOTÓN AGREGAR
                  // ======================================================
                  SizedBox(
                    width: double.infinity,
                    height: 41,
                    child: ElevatedButton.icon(
                      onPressed: onAgregar,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                      ),
                      label: Text(
                        textoAgregar,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cafe,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

