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
  // OFERTAS
  // ================================================================

  final List<Map<String, dynamic>> ofertas = [
    {
      'index': 0,
      'nombre': 'Postre de capuchino',
      'nombreEn': 'Cappuccino Dessert',
      'precioAnterior': '\$15.000',
      'precio': '\$12.000',
      'descripcion':
          'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café.',
      'descripcionEn':
          'Delicious cappuccino dessert made with smooth cream and an intense coffee flavor.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
    },
    {
      'index': 1,
      'nombre': 'Postre de mora',
      'nombreEn': 'Blackberry Dessert',
      'precioAnterior': '\$11.000',
      'precio': '\$9.000',
      'descripcion':
          'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora.',
      'descripcionEn':
          'Delicious blackberry dessert made with a creamy mixture and a delicious blackberry flavor.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 2,
      'nombre': 'Torta de tres leches',
      'nombreEn': 'Tres Leches Cake',
      'precioAnterior': '\$25.000',
      'precio': '\$20.000',
      'descripcion':
          'Suave y deliciosa torta de tres leches con una textura húmeda y cremosa.',
      'descripcionEn':
          'Soft and delicious tres leches cake with a moist and creamy texture.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 3,
      'nombre': 'Torta de café',
      'nombreEn': 'Coffee Cake',
      'precioAnterior': '\$30.000',
      'precio': '\$24.000',
      'descripcion':
          'Deliciosa torta de café con un suave sabor y aroma a café.',
      'descripcionEn':
          'Delicious coffee cake with a smooth coffee flavor and aroma.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
    },
    {
      'index': 4,
      'nombre': 'Cheesecake de fresa',
      'nombreEn': 'Strawberry Cheesecake',
      'precioAnterior': '\$40.000',
      'precio': '\$32.000',
      'descripcion':
          'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
      'descripcionEn':
          'Delicious strawberry cheesecake with a creamy texture and sweet strawberry topping.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 5,
      'nombre': 'Brownie de chocolate',
      'nombreEn': 'Chocolate Brownie',
      'precioAnterior': '\$22.000',
      'precio': '\$18.000',
      'descripcion':
          'Suave y delicioso brownie de chocolate con un intenso sabor a chocolate.',
      'descripcionEn':
          'Soft and delicious chocolate brownie with an intense chocolate flavor.',
      'icono': Icons.cookie,
      'descuento': '20% OFF',
    },
    {
      'index': 6,
      'nombre': 'Cupcake de vainilla',
      'nombreEn': 'Vanilla Cupcake',
      'precioAnterior': '\$15.000',
      'precio': '\$12.000',
      'descripcion':
          'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
      'descripcionEn':
          'Fluffy vanilla cupcake with smooth cream and a delicious sweet touch.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 7,
      'nombre': 'Tarta de limón',
      'nombreEn': 'Lemon Tart',
      'precioAnterior': '\$28.000',
      'precio': '\$22.000',
      'descripcion':
          'Deliciosa tarta de limón con un equilibrio perfecto entre dulce y refrescante.',
      'descripcionEn':
          'Delicious lemon tart with a perfect balance between sweet and refreshing.',
      'icono': Icons.pie_chart,
      'descuento': '20% OFF',
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
  // CARRITO
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: cafeOscuro,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                '${oferta['nombre']} ${t('agregado_carrito')}',
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
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        final es = locale.languageCode == 'es';

        final esOscuro = Theme.of(context).brightness == Brightness.dark;

        // ============================================================
        // COLORES DINÁMICOS
        // ============================================================

        final fondo = esOscuro ? const Color(0xFF1E1714) : crema;

        final superficie = esOscuro ? const Color(0xFF2B211D) : cremaClara;

        final superficieSuave = esOscuro ? const Color(0xFF3A2B25) : crema;

        final textoPrincipal = esOscuro ? const Color(0xFFFFF8E7) : cafeOscuro;

        final textoSecundario = esOscuro ? const Color(0xFFD7C5B8) : cafeClaro;

        return Scaffold(
          backgroundColor: fondo,

          // ==========================================================
          // APP BAR
          // ==========================================================
          appBar: AppBar(
            backgroundColor: esOscuro ? const Color(0xFF1E1714) : cafeOscuro,

            foregroundColor: Colors.white,

            elevation: 0,

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

            centerTitle: true,
          ),

          // ==========================================================
          // CONTENIDO
          // ==========================================================
          body: Column(
            children: [
              // ========================================================
              // ENCABEZADO DE OFERTAS
              // ========================================================
              Container(
                width: double.infinity,

                margin: const EdgeInsets.fromLTRB(16, 16, 16, 5),

                padding: const EdgeInsets.all(18),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [cafeOscuro, cafe],
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
                        crossAxisAlignment: CrossAxisAlignment.start,

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
              // GRID DE OFERTAS
              // ========================================================
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(16),

                  itemCount: ofertas.length,

                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 0.60,
                  ),
                 itemBuilder: (context, index) {
  final oferta = ofertas[index];

  final favorito = esFavorito(oferta['index']);

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
