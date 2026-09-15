import 'package:flutter/material.dart';

import '../carrito_data.dart';
import '../favoritos_data.dart';
import '../idioma_data.dart';

import '../components/detalle_producto/detalle_producto_info.dart';
import '../components/detalle_producto/detalle_producto_cantidad.dart';
import '../components/detalle_producto/detalle_producto_boton.dart';
import '../components/detalle_producto/detalle_producto_imagen.dart';

class DetalleProductoPage extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetalleProductoPage({
    super.key,
    required this.producto,
  });

  @override
  State<DetalleProductoPage> createState() =>
      _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  int cantidad = 1;

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);

  // ================================================================
  // FAVORITOS
  // ================================================================

  bool esFavorito() {
    return FavoritosData.favoritos.any(
      (productoFavorito) =>
          productoFavorito['index'] == widget.producto['index'],
    );
  }

  void agregarFavorito() {
    setState(() {
      if (esFavorito()) {
        FavoritosData.favoritos.removeWhere(
          (productoFavorito) =>
              productoFavorito['index'] == widget.producto['index'],
        );
      } else {
        FavoritosData.favoritos.add({
          'index': widget.producto['index'],
          'nombre': widget.producto['nombre'],
          'precio': widget.producto['precio'],
          'descripcion': widget.producto['descripcion'],
          'icono': widget.producto['icono'],
        });
      }
    });
  }

  // ================================================================
  // CARRITO
  // ================================================================

  void agregarCarrito() {
    setState(() {
      final indexExistente = CarritoData.carrito.indexWhere(
        (productoCarrito) =>
            productoCarrito['index'] == widget.producto['index'],
      );

      if (indexExistente != -1) {
        CarritoData.carrito[indexExistente]['cantidad'] += cantidad;
      } else {
        CarritoData.carrito.add({
          'index': widget.producto['index'],
          'nombre': widget.producto['nombre'],
          'precio': widget.producto['precio'],
          'descripcion': widget.producto['descripcion'],
          'icono': widget.producto['icono'],
          'cantidad': cantidad,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${widget.producto['nombre']} '
          '${IdiomaData.texto('agregado_carrito')}',
        ),
        duration: const Duration(seconds: 1),
        backgroundColor: cafeOscuro,
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        final bool es = locale.languageCode == 'es';

        final bool oscuro =
            Theme.of(context).brightness == Brightness.dark;

        final Color fondoPagina = oscuro
            ? const Color(0xFF1E1714)
            : const Color(0xFFFFFBF5);

        final Color textoSecundario = oscuro
            ? Colors.white54
            : const Color(0xFF8A7B73);

        return Scaffold(
          backgroundColor: fondoPagina,

          // ==========================================================
          // APP BAR
          // ==========================================================

          appBar: AppBar(
            title: Text(
              IdiomaData.texto('detalle_producto'),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: cafeOscuro,
            foregroundColor: Colors.white,
            actions: [
              IconButton(
                onPressed: agregarFavorito,
                icon: Icon(
                  esFavorito()
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: esFavorito()
                      ? Colors.red.shade200
                      : Colors.white,
                ),
              ),
            ],
          ),

          // ==========================================================
          // CONTENIDO
          // ==========================================================

          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ======================================================
                // IMAGEN
                // ======================================================

                DetalleProductoImagen(
                  icono: producto['icono'] as IconData,
                  oscuro: oscuro,
                ),

                const SizedBox(height: 25),

                // ======================================================
                // INFORMACIÓN
                // ======================================================

                DetalleProductoInfo(
                  nombre: producto['nombre'] as String,
                  precio: producto['precio'] as String,
                  descripcion: producto['descripcion'] as String,
                  oscuro: oscuro,
                ),

                const SizedBox(height: 25),

                // ======================================================
                // CANTIDAD
                // ======================================================

                DetalleProductoCantidad(
                  cantidad: cantidad,
                  oscuro: oscuro,
                  titulo: IdiomaData.texto('cantidad'),
                  onDisminuir: () {
                    if (cantidad > 1) {
                      setState(() {
                        cantidad--;
                      });
                    }
                  },
                  onAumentar: () {
                    setState(() {
                      cantidad++;
                    });
                  },
                ),

                const SizedBox(height: 25),

                // ======================================================
                // BOTÓN CARRITO
                // ======================================================

                DetalleProductoBoton(
                  texto: IdiomaData.texto(
                    'agregar_al_carrito',
                  ),
                  onPressed: agregarCarrito,
                ),

                const SizedBox(height: 15),

                // ======================================================
                // PRODUCTO SELECCIONADO
                // ======================================================

                Center(
                  child: Text(
                    '${IdiomaData.texto('producto_seleccionado')}: '
                    '${producto['nombre']}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textoSecundario,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }
}
