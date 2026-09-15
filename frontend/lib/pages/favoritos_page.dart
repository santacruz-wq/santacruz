
import 'package:flutter/material.dart';
import '../favoritos_data.dart';
import '../idioma_data.dart';
import '../components/favoritos/favorito_card.dart';

class FavoritosPage extends StatefulWidget {
  const FavoritosPage({super.key});

  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
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

  // ================================================================
  // TRADUCCIONES
  // ================================================================

  String t(String clave) {
    return IdiomaData.texto(clave);
  }

  // ================================================================
  // OBTENER NOMBRE DEL PRODUCTO SEGÚN EL IDIOMA
  // ================================================================

  String obtenerNombre(Map<String, dynamic> producto, bool es) {
    if (es) {
      return producto['nombreEs'] ?? producto['nombre'] ?? 'Producto';
    } else {
      return producto['nombreEn'] ?? producto['nombre'] ?? 'Product';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        final favoritos = FavoritosData.favoritos;

        final bool es = locale.languageCode == 'es';

        final bool oscuro =
            Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor:
              oscuro ? const Color(0xFF1E1714) : crema,

          // ============================================================
          // APP BAR
          // ============================================================

          appBar: AppBar(
            backgroundColor:
                oscuro ? const Color(0xFF1E1714) : cafeOscuro,
            foregroundColor: Colors.white,
            elevation: 0,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: dorado,
                    borderRadius: BorderRadius.circular(11),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 21,
                  ),
                ),

                const SizedBox(width: 10),

                Text(
                  t('favoritos'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
            centerTitle: true,
          ),

          // ============================================================
          // CUERPO
          // ============================================================

          body: favoritos.isEmpty

              // ========================================================
              // SIN FAVORITOS
              // ========================================================

              ? Center(
                  child: Container(
                    margin: const EdgeInsets.all(25),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 32,
                    ),
                    decoration: BoxDecoration(
                      color: oscuro
                          ? const Color(0xFF2B211D)
                          : cremaClara,
                      borderRadius: BorderRadius.circular(26),
                      border: Border.all(
                        color: oscuro
                            ? cafeClaro.withValues(alpha: 0.25)
                            : doradoClaro,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: oscuro ? 0.20 : 0.07,
                          ),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(22),
                          decoration: BoxDecoration(
                            color: doradoClaro.withValues(alpha: 0.25),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            size: 68,
                            color: dorado,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          t('no_favoritos'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color:
                                oscuro ? Colors.white : cafeOscuro,
                          ),
                        ),

                        const SizedBox(height: 9),

                        Text(
                          t('agrega_favoritos'),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: oscuro
                                ? const Color(0xFFD7C4BA)
                                : cafeClaro,
                            fontSize: 14,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  ),
                )

              // ========================================================
              // LISTA DE FAVORITOS
              // ========================================================

              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    18,
                    16,
                    20,
                  ),
                  itemCount: favoritos.length,
                  itemBuilder: (context, index) {
                    final producto = favoritos[index];

                    final String nombreProducto =
                        obtenerNombre(producto, es);

                    return FavoritoCard(
                      producto: producto,
                      nombreProducto: nombreProducto,
                      textoFavorito: t('producto_favorito'),
                      textoEliminar: t('favorito_eliminado'),
                      onEliminar: () {
                        setState(() {
                          FavoritosData.favoritos.removeAt(index);
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: cafeOscuro,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            content: Text(
                              t('favorito_eliminado'),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            duration:
                                const Duration(seconds: 1),
                          ),
                        );
                      },
                    );
                  },
                ),
        );
      },
    );
  }
}

