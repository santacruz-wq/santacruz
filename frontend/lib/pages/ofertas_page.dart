import 'dart:async';

import 'package:flutter/material.dart';

import '../favoritos_data.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';
import '../components/ofertas/ofertas_card.dart';

class OfertasPage extends StatefulWidget {
  const OfertasPage({super.key});

  @override
  State<OfertasPage> createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage> {
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
  // FILTRO DE CATEGORÍAS
  // ================================================================

  String categoriaSeleccionada = 'Todas';

  List<Map<String, dynamic>> get ofertasFiltradas {
    if (categoriaSeleccionada == 'Todas') {
      return ofertas;
    }

    return ofertas.where((oferta) {
      return oferta['categoria'] == categoriaSeleccionada;
    }).toList();
  }

  Widget filtroCategoria(
    String categoria,
    String texto,
    IconData icono,
    bool esOscuro,
    Color textoPrincipal,
  ) {
    final seleccionado = categoriaSeleccionada == categoria;

    return InkWell(
      onTap: () {
        setState(() {
          categoriaSeleccionada = categoria;
        });
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: seleccionado
              ? dorado
              : (esOscuro
                  ? const Color(0xFF3A2B25)
                  : crema),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: seleccionado
                ? dorado
                : dorado.withValues(alpha: 0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              size: 16,
              color: seleccionado ? Colors.white : dorado,
            ),
            const SizedBox(width: 6),
            Text(
              texto,
              style: TextStyle(
                color: seleccionado
                    ? Colors.white
                    : textoPrincipal,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================================================================
  // CONTADOR OFERTA DEL DÍA
  // ================================================================

  Timer? _temporizador;

  Duration _tiempoRestante = const Duration(
    hours: 5,
    minutes: 59,
    seconds: 59,
  );

  @override
  void initState() {
    super.initState();

    _temporizador = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (_tiempoRestante.inSeconds <= 0) {
          timer.cancel();
          return;
        }

        if (mounted) {
          setState(() {
            _tiempoRestante -= const Duration(seconds: 1);
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  String obtenerTiempoRestante() {
    final horas = _tiempoRestante.inHours
        .toString()
        .padLeft(2, '0');

    final minutos = (_tiempoRestante.inMinutes % 60)
        .toString()
        .padLeft(2, '0');

    final segundos = (_tiempoRestante.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$horas:$minutos:$segundos';
  }

  // ================================================================
  // OFERTAS NORMALES
  // ================================================================

  final List<Map<String, dynamic>> ofertas = [
    {
      'index': 0,
      'nombre': 'Postre de capuchino',
      'nombreEn': 'Cappuccino Dessert',
      'precioAnterior': '\$15.000',
      'precio': '\$12.000',
      'ahorro': '\$3.000',
      'descripcion':
          'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café.',
      'descripcionEn':
          'Delicious cappuccino dessert made with smooth cream and an intense coffee flavor.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
      'categoria': 'Café',
    },
    {
      'index': 1,
      'nombre': 'Postre de mora',
      'nombreEn': 'Blackberry Dessert',
      'precioAnterior': '\$11.000',
      'precio': '\$9.000',
      'ahorro': '\$2.000',
      'descripcion':
          'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora.',
      'descripcionEn':
          'Delicious blackberry dessert made with a creamy mixture and a delicious blackberry flavor.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
      'categoria': 'Postres',
    },
    {
      'index': 2,
      'nombre': 'Torta de tres leches',
      'nombreEn': 'Tres Leches Cake',
      'precioAnterior': '\$25.000',
      'precio': '\$20.000',
      'ahorro': '\$5.000',
      'descripcion':
          'Suave y deliciosa torta de tres leches con una textura húmeda y cremosa.',
      'descripcionEn':
          'Soft and delicious tres leches cake with a moist and creamy texture.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
      'categoria': 'Tortas',
    },
    {
      'index': 3,
      'nombre': 'Torta de café',
      'nombreEn': 'Coffee Cake',
      'precioAnterior': '\$30.000',
      'precio': '\$24.000',
      'ahorro': '\$6.000',
      'descripcion':
          'Deliciosa torta de café con un suave sabor y aroma a café.',
      'descripcionEn':
          'Delicious coffee cake with a smooth coffee flavor and aroma.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
      'categoria': 'Café',
    },
    {
      'index': 4,
      'nombre': 'Cheesecake de fresa',
      'nombreEn': 'Strawberry Cheesecake',
      'precioAnterior': '\$40.000',
      'precio': '\$32.000',
      'ahorro': '\$8.000',
      'descripcion':
          'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
      'descripcionEn':
          'Delicious strawberry cheesecake with a creamy texture and sweet strawberry topping.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
      'categoria': 'Tortas',
    },
    {
      'index': 5,
      'nombre': 'Brownie de chocolate',
      'nombreEn': 'Chocolate Brownie',
      'precioAnterior': '\$22.000',
      'precio': '\$18.000',
      'ahorro': '\$4.000',
      'descripcion':
          'Suave y delicioso brownie de chocolate con un intenso sabor a chocolate.',
      'descripcionEn':
          'Soft and delicious chocolate brownie with an intense chocolate flavor.',
      'icono': Icons.cookie,
      'descuento': '20% OFF',
      'categoria': 'Brownies',
    },
    {
      'index': 6,
      'nombre': 'Cupcake de vainilla',
      'nombreEn': 'Vanilla Cupcake',
      'precioAnterior': '\$15.000',
      'precio': '\$12.000',
      'ahorro': '\$3.000',
      'descripcion':
          'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
      'descripcionEn':
          'Fluffy vanilla cupcake with smooth cream and a delicious sweet touch.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
      'categoria': 'Postres',
    },
    {
      'index': 7,
      'nombre': 'Tarta de limón',
      'nombreEn': 'Lemon Tart',
      'precioAnterior': '\$28.000',
      'precio': '\$22.000',
      'ahorro': '\$6.000',
      'descripcion':
          'Deliciosa tarta de limón con un equilibrio perfecto entre dulce y refrescante.',
      'descripcionEn':
          'Delicious lemon tart with a perfect balance between sweet and refreshing.',
      'icono': Icons.pie_chart,
      'descuento': '20% OFF',
      'categoria': 'Postres',
    },
  ];

  // ================================================================
  // COMBOS ESPECIALES
  // ================================================================

  final List<Map<String, dynamic>> combos = [
    {
      'index': 100,
      'nombre': 'Combo Café',
      'nombreEn': 'Coffee Combo',
      'productos': 'Capuchino + Brownie',
      'productosEn': 'Cappuccino + Brownie',
      'precioAnterior': '\$37.000',
      'precio': '\$29.000',
      'ahorro': '\$8.000',
      'icono': Icons.local_cafe,
    },
    {
      'index': 101,
      'nombre': 'Combo Dulce',
      'nombreEn': 'Sweet Combo',
      'productos': 'Postre de mora + Cupcake',
      'productosEn': 'Blackberry Dessert + Cupcake',
      'precioAnterior': '\$26.000',
      'precio': '\$22.000',
      'ahorro': '\$4.000',
      'icono': Icons.cake,
    },
    {
      'index': 102,
      'nombre': 'Combo Torta',
      'nombreEn': 'Cake Combo',
      'productos': 'Tres leches + Postre de capuchino',
      'productosEn': 'Tres Leches + Cappuccino Dessert',
      'precioAnterior': '\$40.000',
      'precio': '\$34.000',
      'ahorro': '\$6.000',
      'icono': Icons.celebration,
    },
  ];

  // ================================================================
  // TRADUCCIONES
  // ================================================================

  String t(String clave) {
    return IdiomaData.texto(clave);
  }

  // ================================================================
  // FAVORITOS
  // ================================================================

  bool esFavorito(int index) {
    return FavoritosData.favoritos.any(
      (producto) => producto['index'] == index,
    );
  }

  void alternarFavorito(Map<String, dynamic> oferta) {
    final index = oferta['index'];

    setState(() {
      final existe = FavoritosData.favoritos.any(
        (producto) => producto['index'] == index,
      );

      if (existe) {
        FavoritosData.favoritos.removeWhere(
          (producto) => producto['index'] == index,
        );
      } else {
        FavoritosData.favoritos.add({
          'index': oferta['index'],
          'nombre': oferta['nombre'],
          'nombreEn': oferta['nombreEn'],
          'precio': oferta['precio'],
          'descripcion': oferta['descripcion'],
          'descripcionEn': oferta['descripcionEn'],
          'icono': oferta['icono'],
        });
      }
    });
  }

  // ================================================================
  // FAVORITOS DE COMBOS
  // ================================================================

  bool esFavoritoCombo(int index) {
    return FavoritosData.favoritos.any(
      (producto) => producto['index'] == index,
    );
  }

  void alternarFavoritoCombo(Map<String, dynamic> combo) {
    final index = combo['index'];

    setState(() {
      final existe = FavoritosData.favoritos.any(
        (producto) => producto['index'] == index,
      );

      if (existe) {
        FavoritosData.favoritos.removeWhere(
          (producto) => producto['index'] == index,
        );
      } else {
        FavoritosData.favoritos.add({
          'index': combo['index'],
          'nombre': combo['nombre'],
          'nombreEn': combo['nombreEn'],
          'precio': combo['precio'],
          'descripcion': combo['productos'],
          'descripcionEn': combo['productosEn'],
          'icono': combo['icono'],
        });
      }
    });
  }

  // ================================================================
  // AGREGAR OFERTA AL CARRITO
  // ================================================================

  void agregarAlCarrito(Map<String, dynamic> oferta) {
    CarritoData.agregarProducto({
      'index': oferta['index'],
      'nombre': oferta['nombre'],
      'nombreEn': oferta['nombreEn'],
      'precio': oferta['precio'],
      'descripcion': oferta['descripcion'],
      'descripcionEn': oferta['descripcionEn'],
      'icono': oferta['icono'],
    });

    mostrarMensaje(
      '${oferta['nombre']} ${t('agregado_carrito')}',
    );
  }

  // ================================================================
  // OFERTA DEL DÍA
  // ================================================================

  void agregarOfertaDelDia() {
    CarritoData.agregarProducto({
      'index': 90,
      'nombre': 'Combo Capuchino + Brownie',
      'nombreEn': 'Cappuccino + Brownie Combo',
      'precio': '\$29.000',
      'descripcion':
          'Combo especial de capuchino y brownie.',
      'descripcionEn':
          'Special cappuccino and brownie combo.',
      'icono': Icons.local_cafe,
    });

    mostrarMensaje(
      'Oferta del día agregada al carrito',
    );
  }

  // ================================================================
  // AGREGAR COMBO
  // ================================================================

  void agregarCombo(Map<String, dynamic> combo) {
    CarritoData.agregarProducto({
      'index': combo['index'],
      'nombre': combo['nombre'],
      'nombreEn': combo['nombreEn'],
      'precio': combo['precio'],
      'descripcion': combo['productos'],
      'descripcionEn': combo['productosEn'],
      'icono': combo['icono'],
    });

    mostrarMensaje(
      '${combo['nombre']} agregado al carrito',
    );
  }

  // ================================================================
  // MENSAJE
  // ================================================================

  void mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cafeOscuro,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.white,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                mensaje,
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
  // TARJETA DE COMBO
  // ================================================================

  Widget tarjetaCombo({
    required Map<String, dynamic> combo,
    required bool es,
    required bool esOscuro,
    required Color superficie,
    required Color textoPrincipal,
    required Color textoSecundario,
  }) {
    return Container(
      width: 285,
      margin: const EdgeInsets.only(right: 14),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: superficie,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: dorado.withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.07),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: esOscuro
                      ? const Color(0xFF3A2B25)
                      : crema,
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  combo['icono'],
                  color: dorado,
                  size: 27,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  es
                      ? combo['nombre']
                      : combo['nombreEn'],
                  style: TextStyle(
                    color: textoPrincipal,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 7,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: dorado,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'OFERTA',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              InkWell(
                onTap: () => alternarFavoritoCombo(combo),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: esOscuro
                        ? const Color(0xFF3A2B25)
                        : crema,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    esFavoritoCombo(combo['index'])
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: esFavoritoCombo(combo['index'])
                        ? Colors.red
                        : textoSecundario,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            es
                ? combo['productos']
                : combo['productosEn'],
            style: TextStyle(
              color: textoSecundario,
              fontSize: 12,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Text(
                combo['precioAnterior'],
                style: TextStyle(
                  color: textoSecundario,
                  fontSize: 12,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                combo['precio'],
                style: TextStyle(
                  color: dorado,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            es
                ? 'Ahorras ${combo['ahorro']}'
                : 'You save ${combo['ahorro']}',
            style: TextStyle(
              color: textoSecundario,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 9),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => agregarCombo(combo),
              icon: const Icon(
                Icons.shopping_cart_outlined,
                size: 17,
              ),
              label: Text(
                es
                    ? 'Agregar al carrito'
                    : 'Add to cart',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  vertical: 9,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ),
        ],
      ),
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
        final es = locale.languageCode == 'es';
        final esOscuro =
            Theme.of(context).brightness == Brightness.dark;

        final fondo =
            esOscuro ? const Color(0xFF1E1714) : crema;

        final superficie =
            esOscuro ? const Color(0xFF2B211D) : cremaClara;

        final textoPrincipal =
            esOscuro ? const Color(0xFFFFF8E7) : cafeOscuro;

        final textoSecundario =
            esOscuro ? const Color(0xFFD7C5B8) : cafeClaro;

        return Scaffold(
          backgroundColor: fondo,

          // ==========================================================
          // APP BAR
          // ==========================================================

          appBar: AppBar(
            backgroundColor:
                esOscuro ? const Color(0xFF1E1714) : cafeOscuro,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: dorado,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.local_offer,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  t('ofertas'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          ),

          // ==========================================================
          // CONTENIDO
          // ==========================================================

          body: ListView(
            padding: const EdgeInsets.only(bottom: 25),
            children: [
              // ========================================================
              // ENCABEZADO
              // ========================================================

              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  8,
                ),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      cafeOscuro,
                      cafe,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: cafeOscuro.withValues(alpha: 0.20),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: dorado,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.local_offer,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            t('ofertas_especiales'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            t('disfruta_ofertas'),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.local_fire_department,
                      color: doradoClaro,
                      size: 30,
                    ),
                  ],
                ),
              ),

              // ========================================================
              // OFERTA DEL DÍA
              // ========================================================

              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  gradient: LinearGradient(
                    colors: esOscuro
                        ? [
                            const Color(0xFF3A2923),
                            const Color(0xFF2B211D),
                          ]
                        : [
                            const Color(0xFFFFF8E7),
                            const Color(0xFFF7E7C4),
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(
                    color: dorado.withValues(alpha: 0.65),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: esOscuro ? 0.22 : 0.08,
                      ),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: dorado,
                              borderRadius:
                                  BorderRadius.circular(11),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.local_fire_department,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  es
                                      ? 'OFERTA DEL DÍA'
                                      : 'DEAL OF THE DAY',
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
                          const Spacer(),
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 9,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: dorado.withValues(alpha: 0.14),
                              borderRadius:
                                  BorderRadius.circular(9),
                            ),
                            child: Text(
                              '20% OFF',
                              style: TextStyle(
                                color: dorado,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: esOscuro
                                  ? const Color(0xFF4A352C)
                                  : crema,
                              borderRadius:
                                  BorderRadius.circular(18),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: esOscuro ? 0.18 : 0.06,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.local_cafe,
                              color: dorado,
                              size: 38,
                            ),
                          ),
                          const SizedBox(width: 13),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  es
                                      ? 'Combo Capuchino + Brownie'
                                      : 'Cappuccino + Brownie Combo',
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  es
                                      ? 'Una combinación deliciosa para disfrutar hoy.'
                                      : 'A delicious combination to enjoy today.',
                                  style: TextStyle(
                                    color: textoSecundario,
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(
                        children: [
                          Text(
                            '\$37.000',
                            style: TextStyle(
                              color: textoSecundario.withValues(
                                alpha: 0.70,
                              ),
                              fontSize: 13,
                              decoration:
                                  TextDecoration.lineThrough,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            '\$29.000',
                            style: TextStyle(
                              color: dorado,
                              fontSize: 23,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: agregarOfertaDelDia,
                            icon: const Icon(
                              Icons.shopping_cart_outlined,
                              size: 17,
                            ),
                            label: Text(
                              es ? 'Agregar' : 'Add',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: cafe,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              padding:
                                  const EdgeInsets.symmetric(
                                horizontal: 13,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 7),

                      Row(
                        children: [
                          const Icon(
                            Icons.savings_outlined,
                            color: dorado,
                            size: 16,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            es
                                ? 'Ahorras \$8.000'
                                : 'You save \$8.000',
                            style: const TextStyle(
                              color: dorado,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 11,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: dorado.withValues(alpha: 0.10),
                          borderRadius:
                              BorderRadius.circular(11),
                          border: Border.all(
                            color: dorado.withValues(alpha: 0.20),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: dorado,
                              size: 18,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              es
                                  ? 'Termina en:'
                                  : 'Ends in:',
                              style: TextStyle(
                                color: textoSecundario,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              obtenerTiempoRestante(),
                              style: const TextStyle(
                                color: dorado,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // COMBOS ESPECIALES
              // ========================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  10,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.card_giftcard,
                      color: dorado,
                      size: 21,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      es
                          ? 'Combos especiales'
                          : 'Special combos',
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 245,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.only(left: 16),
                  itemCount: combos.length,
                  itemBuilder: (context, index) {
                    final combo = combos[index];

                    return tarjetaCombo(
                      combo: combo,
                      es: es,
                      esOscuro: esOscuro,
                      superficie: superficie,
                      textoPrincipal: textoPrincipal,
                      textoSecundario: textoSecundario,
                    );
                  },
                ),
              ),

              // ========================================================
              // MÁS OFERTAS
              // ========================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  2,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.local_offer_outlined,
                      color: dorado,
                      size: 20,
                    ),
                    const SizedBox(width: 7),
                    Text(
                      es
                          ? 'Más ofertas especiales'
                          : 'More special offers',
                      style: TextStyle(
                        color: textoPrincipal,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // ========================================================
              // FILTROS DE CATEGORÍAS
              // ========================================================

              Padding(
                padding: const EdgeInsets.fromLTRB(
                  16,
                  12,
                  16,
                  4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      filtroCategoria(
                        'Todas',
                        es ? 'Todas' : 'All',
                        Icons.apps_outlined,
                        esOscuro,
                        textoPrincipal,
                      ),
                      const SizedBox(width: 8),
                      filtroCategoria(
                        'Tortas',
                        es ? 'Tortas' : 'Cakes',
                        Icons.cake_outlined,
                        esOscuro,
                        textoPrincipal,
                      ),
                      const SizedBox(width: 8),
                      filtroCategoria(
                        'Postres',
                        es ? 'Postres' : 'Desserts',
                        Icons.icecream_outlined,
                        esOscuro,
                        textoPrincipal,
                      ),
                      const SizedBox(width: 8),
                      filtroCategoria(
                        'Brownies',
                        'Brownies',
                        Icons.cookie_outlined,
                        esOscuro,
                        textoPrincipal,
                      ),
                      const SizedBox(width: 8),
                      filtroCategoria(
                        'Café',
                        es ? 'Café' : 'Coffee',
                        Icons.local_cafe_outlined,
                        esOscuro,
                        textoPrincipal,
                      ),
                    ],
                  ),
                ),
              ),

              // ========================================================
              // GRID DE OFERTAS
              // ========================================================

              Padding(
                padding: const EdgeInsets.all(16),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(),
                  itemCount: ofertasFiltradas.length,
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.60,
                  ),
                  itemBuilder: (context, index) {
                    final oferta = ofertasFiltradas[index];

                    final favorito =
                        esFavorito(oferta['index']);

                    return OfertaCard(
                      oferta: oferta,
                      es: es,
                      favorito: favorito,
                      esOscuro: esOscuro,
                      superficie: superficie,
                      textoPrincipal: textoPrincipal,
                      textoSecundario: textoSecundario,
                      textoAgregar: t('agregar'),
                      onFavorito: () {
                        alternarFavorito(oferta);
                      },
                      onAgregar: () {
                        agregarAlCarrito(oferta);
                      },
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