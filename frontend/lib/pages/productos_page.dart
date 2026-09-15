import 'package:flutter/material.dart';

import '../favoritos_data.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';
import 'detalle_producto_page.dart';

import '../components/productos/producto_header.dart';
import '../components/productos/producto_tarjeta.dart';
import '../components/productos/producto_appbar.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  // ================================================================
  // COLORES
  // ================================================================

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);
  static const Color dorado = Color(0xFFD4A017);
  static const Color doradoClaro = Color(0xFFF3D27A);

  // ================================================================
  // PRODUCTOS
  // ================================================================

  final List<Map<String, dynamic>> productos = [
    {
      'nombreEs': 'Postre de capuchino',
      'nombreEn': 'Cappuccino dessert',
      'precio': '\$15.000',
      'descripcionEs':
          'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café. Perfecto para disfrutar en cualquier momento.',
      'descripcionEn':
          'Delicious cappuccino dessert made with a smooth cream and an intense coffee flavor. Perfect to enjoy at any time.',
      'icono': Icons.coffee,
    },
    {
      'nombreEs': 'Postre de mora',
      'nombreEn': 'Blackberry dessert',
      'precio': '\$11.000',
      'descripcionEs':
          'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora. Una combinación dulce y refrescante.',
      'descripcionEn':
          'Delicious blackberry dessert prepared with a creamy mixture and the delicious flavor of blackberry. A sweet and refreshing combination.',
      'icono': Icons.cake,
    },
    {
      'nombreEs': 'Torta de tres leches',
      'nombreEn': 'Tres leches cake',
      'precio': '\$25.000',
      'descripcionEs':
          'Suave y deliciosa torta de tres leches, preparada para ofrecer una textura húmeda y cremosa con un sabor irresistible.',
      'descripcionEn':
          'Soft and delicious tres leches cake, prepared to offer a moist and creamy texture with an irresistible flavor.',
      'icono': Icons.cake,
    },
    {
      'nombreEs': 'Torta de café',
      'nombreEn': 'Coffee cake',
      'precio': '\$30.000',
      'descripcionEs':
          'Deliciosa torta de café con un suave sabor y aroma a café. Perfecta para acompañar una bebida caliente.',
      'descripcionEn':
          'Delicious coffee cake with a smooth coffee flavor and aroma. Perfect to enjoy with a hot beverage.',
      'icono': Icons.coffee,
    },
    {
      'nombreEs': 'Cheesecake de fresa',
      'nombreEn': 'Strawberry cheesecake',
      'precio': '\$40.000',
      'descripcionEs':
          'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
      'descripcionEn':
          'Delicious strawberry cheesecake with a creamy texture and a sweet strawberry topping.',
      'icono': Icons.cake,
    },
    {
      'nombreEs': 'Brownie de chocolate',
      'nombreEn': 'Chocolate brownie',
      'precio': '\$22.000',
      'descripcionEs':
          'Suave y delicioso brownie de chocolate, preparado con un intenso sabor a chocolate y una textura irresistible.',
      'descripcionEn':
          'Soft and delicious chocolate brownie, prepared with an intense chocolate flavor and an irresistible texture.',
      'icono': Icons.cookie,
    },
    {
      'nombreEs': 'Cupcake de vainilla',
      'nombreEn': 'Vanilla cupcake',
      'precio': '\$15.000',
      'descripcionEs':
          'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
      'descripcionEn':
          'Fluffy vanilla cupcake with a smooth cream and a delicious sweet touch.',
      'icono': Icons.cake,
    },
    {
      'nombreEs': 'Tarta de limón',
      'nombreEn': 'Lemon pie',
      'precio': '\$28.000',
      'descripcionEs':
          'Deliciosa tarta de limón con una combinación equilibrada entre el sabor dulce y el toque refrescante del limón.',
      'descripcionEn':
          'Delicious lemon pie with a balanced combination of sweetness and the refreshing touch of lemon.',
      'icono': Icons.pie_chart,
    },
  ];

  // ================================================================
  // TRADUCCIÓN
  // ================================================================

  String t(String clave) {
    return IdiomaData.texto(clave);
  }

  Map<String, dynamic> productoTraducido(
    Map<String, dynamic> producto,
    bool es,
  ) {
    return {
      ...producto,
      'nombre': es ? producto['nombreEs'] : producto['nombreEn'],
      'descripcion': es ? producto['descripcionEs'] : producto['descripcionEn'],
    };
  }

  // ================================================================
  // FAVORITOS
  // ================================================================

  bool esFavorito(int index) {
    return FavoritosData.favoritos.any(
      (producto) => producto['index'] == index,
    );
  }

  void alternarFavorito(Map<String, dynamic> producto, int index) {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    final productoActual = productoTraducido(producto, es);

    setState(() {
      final existe = FavoritosData.favoritos.any(
        (productoFavorito) => productoFavorito['index'] == index,
      );

      if (existe) {
        FavoritosData.favoritos.removeWhere(
          (productoFavorito) => productoFavorito['index'] == index,
        );
      } else {
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
  // CARRITO
  // ================================================================

  void agregarAlCarrito(Map<String, dynamic> producto, int index) {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    final productoActual = productoTraducido(producto, es);

    CarritoData.agregarProducto({
      'index': index,
      'nombre': productoActual['nombre'],
      'precio': productoActual['precio'],
      'descripcion': productoActual['descripcion'],
      'icono': productoActual['icono'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cafeOscuro,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${productoActual['nombre']} ${t('agregado_carrito')}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  // ================================================================
  // ABRIR DETALLE
  // ================================================================

  void abrirDetalle(Map<String, dynamic> producto, int index) {
    final bool es = IdiomaData.idioma.value.languageCode == 'es';

    final productoActual = productoTraducido(producto, es);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            DetalleProductoPage(producto: {...productoActual, 'index': index}),
      ),
    );
  }

  // ================================================================
  // TARJETA DE PRODUCTO
  // ================================================================

  Widget tarjetaProducto(
    BuildContext context,
    Map<String, dynamic> producto,
    Map<String, dynamic> productoActual,
    int index,
    bool favorito,
  ) {
    final bool oscuro = Theme.of(context).brightness == Brightness.dark;

    return ProductoTarjeta(
      producto: producto,
      productoActual: productoActual,
      favorito: favorito,
      oscuro: oscuro,
      textoVerDetalle: t('ver_detalle'),
      textoAgregarFavorito: IdiomaData.idioma.value.languageCode == 'es'
          ? 'Agregar a favoritos'
          : 'Add to favorites',
      textoQuitarFavorito: IdiomaData.idioma.value.languageCode == 'es'
          ? 'Quitar de favoritos'
          : 'Remove from favorites',
      textoAgregarCarrito: IdiomaData.idioma.value.languageCode == 'es'
          ? 'Agregar al carrito'
          : 'Add to cart',
      onDetalle: () {
        abrirDetalle(producto, index);
      },
      onFavorito: () {
        alternarFavorito(producto, index);
      },
      onCarrito: () {
        agregarAlCarrito(producto, index);
      },
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
        final bool es = locale.languageCode == 'es';

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,

          // ==========================================================
          // APP BAR
          // ==========================================================
          appBar: ProductoAppBar(titulo: t('productos')),

          // ==========================================================
          // CONTENIDO
          // ==========================================================
          body: Column(
            children: [
              // ========================================================
              // ENCABEZADO
              // ========================================================
              ProductoHeader(
                titulo: t('nuestros_productos'),
                subtitulo: t('descubre_productos'),
              ),

              // ========================================================
              // GRID
              // ========================================================
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                  itemCount: productos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.62,
                  ),
                  itemBuilder: (context, index) {
                    final producto = productos[index];

                    final productoActual = productoTraducido(producto, es);

                    final favorito = esFavorito(index);

                    return tarjetaProducto(
                      context,
                      producto,
                      productoActual,
                      index,
                      favorito,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
