
import 'package:flutter/material.dart';

class ConfirmarProductos extends StatelessWidget {
  final List<Map<String, dynamic>> carrito;
  final bool es;

  final String titulo;
  final String textoCantidad;

  final String Function(Map<String, dynamic> producto, bool es)
      nombreProducto;

  final double Function(String precio) convertirPrecio;

  final String Function(double precio) formatoPrecio;

  final Color cafe;
  final Color cafeOscuro;
  final Color crema;
  final Color dorado;
  final Color textoGris;

  const ConfirmarProductos({
    super.key,
    required this.carrito,
    required this.es,
    required this.titulo,
    required this.textoCantidad,
    required this.nombreProducto,
    required this.convertirPrecio,
    required this.formatoPrecio,
    required this.cafe,
    required this.cafeOscuro,
    required this.crema,
    required this.dorado,
    required this.textoGris,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titulo,
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.bold,
            color: cafeOscuro,
          ),
        ),

        const SizedBox(height: 10),

        ...carrito.map((producto) {
          final nombre = nombreProducto(producto, es);

          final precio =
              convertirPrecio(producto['precio'] as String);

          final cantidad = producto['cantidad'] as int;

          final subtotal = precio * cantidad;

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                    color: crema,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dorado.withOpacity(0.25),
                    ),
                  ),
                  child: Icon(
                    producto['icono'] as IconData,
                    color: cafe,
                    size: 30,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        nombre,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: cafeOscuro,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        '$textoCantidad: $cantidad',
                        style: TextStyle(
                          color: textoGris,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 8),

                Text(
                  formatoPrecio(subtotal),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: dorado,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

