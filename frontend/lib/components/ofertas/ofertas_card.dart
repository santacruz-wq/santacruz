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
  static const Color dorado = Color(0xFFD4A017);
  static const Color doradoClaro = Color(0xFFF3D27A);

  @override
  Widget build(BuildContext context) {
    final String nombre =
        es ? oferta['nombre'] : oferta['nombreEn'];

    final String descripcion =
        es ? oferta['descripcion'] : oferta['descripcionEn'];

    return Container(
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: doradoClaro.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: esOscuro ? 0.20 : 0.07,
            ),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ============================================================
          // PARTE SUPERIOR
          // ============================================================
          Container(
            height: 145,
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
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Stack(
              children: [
                // ICONO DEL PRODUCTO
                Center(
                  child: Icon(
                    oferta['icono'],
                    size: 70,
                    color: esOscuro ? doradoClaro : cafe,
                  ),
                ),

                // DESCUENTO
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: dorado,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.20),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Text(
                      oferta['descuento'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // FAVORITO
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: superficie,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: IconButton(
                      onPressed: onFavorito,
                      icon: Icon(
                        favorito
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: favorito
                            ? Colors.red
                            : textoSecundario,
                        size: 24,
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
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NOMBRE
                  Text(
                    nombre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textoPrincipal,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // PRECIOS
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        oferta['precioAnterior'],
                        style: TextStyle(
                          color: textoSecundario.withValues(alpha: 0.75),
                          fontSize: 13,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          oferta['precio'],
                          style: const TextStyle(
                            color: dorado,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 7),

                  // DESCRIPCIÓN
                  Text(
                    descripcion,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 11,
                      height: 1.3,
                    ),
                  ),

                  const Spacer(),

                  // AGREGAR AL CARRITO
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton.icon(
                      onPressed: onAgregar,
                      icon: const Icon(
                        Icons.shopping_cart_outlined,
                        size: 18,
                      ),
                      label: Text(textoAgregar),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cafe,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
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