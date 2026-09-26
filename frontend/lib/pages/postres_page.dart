import 'package:flutter/material.dart';

import '../producto_data.dart';
import '../favoritos_data.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';

import 'detalle_producto_page.dart';

import '../components/productos/producto_tarjeta.dart';
import '../components/productos/producto_header.dart';
import '../components/productos/producto_appbar.dart';

class PostresPage extends StatefulWidget {
  const PostresPage({super.key});

  @override
  State<PostresPage> createState() => _PostresPageState();
}

class _PostresPageState extends State<PostresPage> {
  // ================================================================
  // PRODUCTOS DE POSTRES
  // ================================================================

  final List<Map<String, dynamic>> productosPostres =
      ProductosData.productos.where((producto) {
    final int index = ProductosData.productos.indexOf(producto);

    return index == 0 || index == 1;
  }).toList();

  // ================================================================
  // PRODUCTO TRADUCIDO
  // ================================================================

  Map<String, dynamic> productoTraducido(
    Map<String, dynamic> producto,
  ) {
    final bool es =
        IdiomaData.idioma.value.languageCode == 'es';

    return {
      ...producto,
      'nombre': es
          ? producto['nombreEs']
          : producto['nombreEn'],
      'descripcion': es
          ? producto['descripcionEs']
          : producto['descripcionEn'],
    };
  }

  // ================================================================
  // FAVORITO
  // ================================================================

  bool esFavorito(int index) {
    return FavoritosData.favoritos.any(
      (producto) => producto['index'] == index,
    );
  }

  void alternarFavorito(
    Map<String, dynamic> producto,
  ) {
    final int index =
        ProductosData.productos.indexOf(producto);

    setState(() {
      final bool favorito = esFavorito(index);

      if (favorito) {
        FavoritosData.favoritos.removeWhere(
          (producto) => producto['index'] == index,
        );
      } else {
        final productoActual =
            productoTraducido(producto);

        FavoritosData.favoritos.add({
          'index': index,
          'nombre': productoActual['nombre'],
          'precio': productoActual['precio'],
          'descripcion': productoActual['descripcion'],
          'icono': productoActual['icono'],
        });
      }
    });
  }

  // ================================================================
  // AGREGAR AL CARRITO
  // ================================================================

  void agregarAlCarrito(
    Map<String, dynamic> producto,
  ) {
    final int index =
        ProductosData.productos.indexOf(producto);

    final productoActual =
        productoTraducido(producto);

    CarritoData.agregarProducto({
      'index': index,
      'nombre': productoActual['nombre'],
      'precio': productoActual['precio'],
      'descripcion': productoActual['descripcion'],
      'icono': productoActual['icono'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          IdiomaData.idioma.value.languageCode == 'es'
              ? 'Producto agregado al carrito'
              : 'Product added to cart',
        ),
      ),
    );
  }

  // ================================================================
  // ABRIR DETALLE
  // ================================================================

  void abrirDetalle(
    Map<String, dynamic> producto,
  ) {
    final productoActual =
        productoTraducido(producto);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => DetalleProductoPage(
          producto: {
            ...productoActual,
            'index':
                ProductosData.productos.indexOf(producto),
          },
        ),
      ),
    );
  }

  // ================================================================
  // TARJETA DEL PRODUCTO
  // ================================================================

  Widget tarjetaProducto(
    Map<String, dynamic> producto,
  ) {
    final productoActual =
        productoTraducido(producto);

    final int index =
        ProductosData.productos.indexOf(producto);

    return ProductoTarjeta(
      producto: producto,
      productoActual: productoActual,
      favorito: esFavorito(index),
      oscuro: IdiomaData.modoOscuro.value,

      textoVerDetalle:
          IdiomaData.idioma.value.languageCode == 'es'
              ? 'Ver detalle'
              : 'View details',

      textoAgregarFavorito:
          IdiomaData.idioma.value.languageCode == 'es'
              ? 'Agregar a favoritos'
              : 'Add to favorites',

      textoQuitarFavorito:
          IdiomaData.idioma.value.languageCode == 'es'
              ? 'Quitar de favoritos'
              : 'Remove from favorites',

      textoAgregarCarrito:
          IdiomaData.idioma.value.languageCode == 'es'
              ? 'Agregar al carrito'
              : 'Add to cart',

      onDetalle: () => abrirDetalle(producto),
      onFavorito: () => alternarFavorito(producto),
      onCarrito: () => agregarAlCarrito(producto),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        return ValueListenableBuilder<bool>(
          valueListenable: IdiomaData.modoOscuro,
          builder: (context, oscuro, child) {
            final bool es =
                locale.languageCode == 'es';

            return Scaffold(
              backgroundColor: oscuro
                  ? const Color(0xFF1E1714)
                  : const Color(0xFFFFFBF5),

              appBar: ProductoAppBar(
                titulo: es ? 'Postres' : 'Desserts',
              ),

              body: Column(
                children: [
                  ProductoHeader(
                    titulo: es ? 'Postres' : 'Desserts',
                    subtitulo: es
                        ? 'Deliciosos postres para disfrutar'
                        : 'Delicious desserts to enjoy',
                  ),

                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10),

                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.57,
                      ),

                      itemCount:
                          productosPostres.length,

                      itemBuilder: (context, index) {
                        return tarjetaProducto(
                          productosPostres[index],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}