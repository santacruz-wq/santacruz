
import 'package:flutter/material.dart';

class FavoritoCard extends StatelessWidget {
  final Map<String, dynamic> producto;
  final String nombreProducto;
  final VoidCallback onEliminar;
  final String textoFavorito;
  final String textoEliminar;

  const FavoritoCard({
    super.key,
    required this.producto,
    required this.nombreProducto,
    required this.onEliminar,
    required this.textoFavorito,
    required this.textoEliminar,
  });

  // ================================================================
  // COLORES DEL DISEÑO
  // ================================================================

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);

  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);

  static const Color dorado = Color(0xFFDDB447);
  static const Color doradoClaro = Color(0xFFF3D27A);

  @override
  Widget build(BuildContext context) {
    final bool oscuro =
        Theme.of(context).brightness == Brightness.dark;

    // ================================================================
    // COLORES SEGÚN EL MODO
    // ================================================================

    final Color fondoTarjeta =
        oscuro ? const Color(0xFF2B211D) : cremaClara;

    final Color fondoIcono =
        oscuro ? const Color(0xFF3A2C26) : crema;

    final Color colorTitulo =
        oscuro ? Colors.white : cafeOscuro;

    final Color colorSecundario =
        oscuro ? const Color(0xFFD7C4BA) : cafeClaro;

    // ================================================================
    // TARJETA
    // ================================================================

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: fondoTarjeta,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: oscuro
              ? cafeClaro.withValues(alpha: 0.25)
              : doradoClaro.withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: oscuro ? 0.20 : 0.07,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // ==========================================================
            // ICONO DEL PRODUCTO
            // ==========================================================

            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: oscuro
                      ? [
                          cafe.withValues(alpha: 0.65),
                          const Color(0xFF3A2C26),
                        ]
                      : [
                          doradoClaro.withValues(alpha: 0.45),
                          crema,
                        ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: fondoIcono,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    producto['icono'] as IconData,
                    size: 34,
                    color: dorado,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ==========================================================
            // INFORMACIÓN DEL PRODUCTO
            // ==========================================================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nombreProducto,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: colorTitulo,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ====================================================
                  // PRECIO
                  // ====================================================

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: dorado.withValues(alpha: 0.13),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      producto['precio'] as String,
                      style: const TextStyle(
                        color: dorado,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ====================================================
                  // TEXTO FAVORITO
                  // ====================================================

                  Row(
                    children: [
                      const Icon(
                        Icons.favorite,
                        color: Colors.red,
                        size: 15,
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          textoFavorito,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorSecundario,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // ==========================================================
            // BOTÓN ELIMINAR
            // ==========================================================

            Container(
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.09),
                borderRadius: BorderRadius.circular(14),
              ),
              child: IconButton(
                tooltip: textoEliminar,
                onPressed: onEliminar,
                icon: const Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 25,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

