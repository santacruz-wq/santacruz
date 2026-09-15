
import 'package:flutter/material.dart';

class ProductoTarjeta extends StatelessWidget {
  final Map<String, dynamic> producto;
  final Map<String, dynamic> productoActual;
  final bool favorito;
  final bool oscuro;

  final String textoVerDetalle;
  final String textoAgregarFavorito;
  final String textoQuitarFavorito;
  final String textoAgregarCarrito;

  final VoidCallback onDetalle;
  final VoidCallback onFavorito;
  final VoidCallback onCarrito;

  const ProductoTarjeta({
    super.key,
    required this.producto,
    required this.productoActual,
    required this.favorito,
    required this.oscuro,
    required this.textoVerDetalle,
    required this.textoAgregarFavorito,
    required this.textoQuitarFavorito,
    required this.textoAgregarCarrito,
    required this.onDetalle,
    required this.onFavorito,
    required this.onCarrito,
  });

  // ================================================================
  // COLORES
  // ================================================================

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color dorado = Color(0xFFD4A017);

  @override
  Widget build(BuildContext context) {
    final Color fondo =
        oscuro ? const Color(0xFF2B211D) : Colors.white;

    final Color texto =
        oscuro ? Colors.white : cafeOscuro;

    final Color textoSecundario =
        oscuro ? Colors.white70 : cafeClaro;

    return Card(
      elevation: 4,
      color: fondo,
      margin: const EdgeInsets.all(6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onDetalle,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =====================================================
              // ICONO Y FAVORITO
              // =====================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: oscuro
                          ? const Color(0xFF3A2C26)
                          : crema,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      productoActual['icono'] as IconData,
                      color: cafe,
                      size: 32,
                    ),
                  ),

                  IconButton(
                    onPressed: onFavorito,
                    tooltip: favorito
                        ? textoQuitarFavorito
                        : textoAgregarFavorito,
                    icon: Icon(
                      favorito
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favorito
                          ? Colors.red
                          : cafeClaro,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // =====================================================
              // NOMBRE
              // =====================================================

              Text(
                productoActual['nombre'],
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: texto,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 5),

              // =====================================================
              // DESCRIPCIÓN
              // =====================================================

              Expanded(
                child: Text(
                  productoActual['descripcion'],
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textoSecundario,
                    fontSize: 12,
                    height: 1.3,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // =====================================================
              // PRECIO
              // =====================================================

              Text(
                productoActual['precio'],
                style: const TextStyle(
                  color: dorado,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // =====================================================
              // BOTÓN AGREGAR AL CARRITO
              // =====================================================

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: onCarrito,
                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                    size: 18,
                  ),
                  label: Text(
                    textoAgregarCarrito,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cafe,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),

              // =====================================================
              // VER DETALLE
              // =====================================================

              Center(
                child: TextButton(
                  onPressed: onDetalle,
                  child: Text(
                    textoVerDetalle,
                    style: TextStyle(
                      color: oscuro ? dorado : cafe,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

