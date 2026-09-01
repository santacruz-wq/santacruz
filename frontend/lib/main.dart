import 'package:flutter/material.dart';

import 'pages/productos_page.dart';
import 'pages/favoritos_page.dart';
import 'pages/carrito_page.dart';
import 'pages/perfil_page.dart';
import 'pages/ofertas_page.dart';
import 'pages/detalle_producto_page.dart';

void main() {
  runApp(const SantaCruzApp());
}

class SantaCruzApp extends StatelessWidget {
  const SantaCruzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Santa Cruz',

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6F4E37)),
        useMaterial3: true,
        fontFamily: 'Arial',
      ),

      home: const InicioPage(),
    );
  }
}

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final TextEditingController buscadorController = TextEditingController();

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
      'index': 0,
      'nombre': 'Postre de capuchino',
      'precio': '\$25.000',
      'descripcion':
          'Delicioso postre de capuchino con un suave sabor a café y una textura cremosa.',
      'icono': Icons.coffee,
    },
    {
      'index': 1,
      'nombre': 'Postre de mora',
      'precio': '\$35.000',
      'descripcion':
          'Delicioso postre de mora con un sabor dulce y refrescante, perfecto para disfrutar en cualquier momento.',
      'icono': Icons.cake,
    },
    {
      'index': 2,
      'nombre': 'Torta de tres leches',
      'precio': '\$45.000',
      'descripcion':
          'Suave y deliciosa torta de tres leches, preparada con una textura esponjosa y cremosa.',
      'icono': Icons.cake,
    },
    {
      'index': 3,
      'nombre': 'Torta de café',
      'precio': '\$55.000',
      'descripcion':
          'Deliciosa torta de café con un intenso sabor y una textura suave, perfecta para acompañar una bebida caliente.',
      'icono': Icons.coffee,
    },
    {
      'index': 4,
      'nombre': 'Cheesecake de fresa',
      'precio': '\$40.000',
      'descripcion':
          'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
      'icono': Icons.cake,
    },
    {
      'index': 5,
      'nombre': 'Brownie de chocolate',
      'precio': '\$22.000',
      'descripcion':
          'Suave y delicioso brownie de chocolate, preparado con un intenso sabor a chocolate y una textura irresistible.',
      'icono': Icons.cookie,
    },
    {
      'index': 6,
      'nombre': 'Cupcake de vainilla',
      'precio': '\$15.000',
      'descripcion':
          'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
      'icono': Icons.cake,
    },
    {
      'index': 7,
      'nombre': 'Tarta de limón',
      'precio': '\$28.000',
      'descripcion':
          'Deliciosa tarta de limón con una combinación equilibrada entre el sabor dulce y el toque refrescante del limón.',
      'icono': Icons.pie_chart,
    },
  ];

  String busqueda = '';

  // ================================================================
  // QUITAR TILDES PARA LA BÚSQUEDA
  // ================================================================

  String normalizarTexto(String texto) {
    return texto
        .toLowerCase()
        .replaceAll('á', 'a')
        .replaceAll('é', 'e')
        .replaceAll('í', 'i')
        .replaceAll('ó', 'o')
        .replaceAll('ú', 'u')
        .replaceAll('ü', 'u')
        .trim();
  }

  @override
  void dispose() {
    buscadorController.dispose();
    super.dispose();
  }

  // ================================================================
  // NAVEGACIÓN
  // ================================================================

  void navegarAPagina(Widget pagina) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => pagina));
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    final textoBusqueda = normalizarTexto(busqueda);

    final productosFiltrados = productos.where((producto) {
      final nombre = normalizarTexto(producto['nombre'].toString());

      return nombre.contains(textoBusqueda);
    }).toList();

    return Scaffold(
      backgroundColor: crema,

      // ============================================================
      // BARRA SUPERIOR
      // ============================================================
      appBar: AppBar(
        backgroundColor: cafeOscuro,
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

              child: const Icon(Icons.coffee, color: Colors.white, size: 21),
            ),

            const SizedBox(width: 10),

            const Text(
              'Santa Cruz',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
            ),
          ],
        ),

        centerTitle: true,

        actions: [
          IconButton(
            tooltip: 'Favoritos',
            onPressed: () {
              navegarAPagina(const FavoritosPage());
            },
            icon: const Icon(Icons.favorite_border, size: 26),
          ),

          IconButton(
            tooltip: 'Carrito',
            onPressed: () {
              navegarAPagina(const CarritoPage());
            },
            icon: const Icon(Icons.shopping_cart_outlined, size: 26),
          ),

          const SizedBox(width: 5),
        ],
      ),

      // ============================================================
      // CUERPO
      // ============================================================
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // ======================================================
              // BUSCADOR
              // ======================================================
              Container(
                decoration: BoxDecoration(
                  color: cremaClara,
                  borderRadius: BorderRadius.circular(17),

                  boxShadow: [
                    BoxShadow(
                      color: cafeOscuro.withValues(alpha: 0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: TextField(
                  controller: buscadorController,

                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },

                  style: const TextStyle(color: cafeOscuro),

                  decoration: InputDecoration(
                    hintText: '¿Qué estás buscando?',

                    hintStyle: TextStyle(
                      color: cafeClaro.withValues(alpha: 0.75),
                    ),

                    prefixIcon: const Icon(Icons.search, color: cafe),

                    suffixIcon: busqueda.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              buscadorController.clear();

                              setState(() {
                                busqueda = '';
                              });
                            },

                            icon: const Icon(Icons.clear, color: cafeClaro),
                          )
                        : null,

                    filled: true,
                    fillColor: cremaClara,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: BorderSide.none,
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(17),
                      borderSide: const BorderSide(color: dorado, width: 2),
                    ),
                  ),
                ),
              ),

              // ======================================================
              // RESULTADOS DE BÚSQUEDA
              // ======================================================
              if (busqueda.isNotEmpty) ...[
                const SizedBox(height: 25),

                const Text(
                  'Resultados de búsqueda',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: cafeOscuro,
                  ),
                ),

                const SizedBox(height: 12),

                if (productosFiltrados.isEmpty)
                  Container(
                    width: double.infinity,

                    padding: const EdgeInsets.all(28),

                    decoration: BoxDecoration(
                      color: cremaClara,
                      borderRadius: BorderRadius.circular(20),
                    ),

                    child: const Column(
                      children: [
                        Icon(Icons.search_off, size: 65, color: cafeClaro),

                        SizedBox(height: 10),

                        Text(
                          'No encontramos productos',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: cafeClaro,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  Column(
                    children: productosFiltrados.map((producto) {
                      return GestureDetector(
                        onTap: () {
                          navegarAPagina(
                            DetalleProductoPage(producto: producto),
                          );
                        },

                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),

                          padding: const EdgeInsets.all(12),

                          decoration: BoxDecoration(
                            color: cremaClara,
                            borderRadius: BorderRadius.circular(18),

                            boxShadow: [
                              BoxShadow(
                                color: cafeOscuro.withValues(alpha: 0.07),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),

                          child: Row(
                            children: [
                              Container(
                                width: 65,
                                height: 65,

                                decoration: BoxDecoration(
                                  color: doradoClaro.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(15),
                                ),

                                child: Icon(
                                  producto['icono'] as IconData,
                                  size: 35,
                                  color: cafe,
                                ),
                              ),

                              const SizedBox(width: 15),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,

                                  children: [
                                    Text(
                                      producto['nombre'] as String,

                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: cafeOscuro,
                                      ),
                                    ),

                                    const SizedBox(height: 5),

                                    Text(
                                      producto['precio'] as String,

                                      style: const TextStyle(
                                        color: dorado,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                                color: cafeClaro,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
              ],

              // ======================================================
              // CONTENIDO NORMAL
              // ======================================================
              if (busqueda.isEmpty) ...[
                const SizedBox(height: 25),

                // ====================================================
                // BIENVENIDA
                // ====================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(23),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [cafeOscuro, cafe, cafeClaro],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(22),

                    boxShadow: [
                      BoxShadow(
                        color: cafeOscuro.withValues(alpha: 0.22),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(9),

                            decoration: BoxDecoration(
                              color: dorado,
                              borderRadius: BorderRadius.circular(13),
                            ),

                            child: const Icon(
                              Icons.coffee,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),

                          const SizedBox(width: 12),

                          const Expanded(
                            child: Text(
                              '¡Bienvenido a Santa Cruz! 👋',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 13),

                      const Text(
                        'Disfruta nuestros productos y encuentra tus favoritos en un solo lugar.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 18),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),

                        decoration: BoxDecoration(
                          color: dorado,
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: const Text(
                          '☕ Sabor que enamora',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // ====================================================
                // CATEGORÍAS
                // ====================================================
                const Text(
                  'Categorías',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: cafeOscuro,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    GestureDetector(
                      onTap: () {
                        navegarAPagina(const ProductosPage());
                      },

                      child: categoria(Icons.shopping_bag, 'Productos'),
                    ),

                    GestureDetector(
                      onTap: () {
                        navegarAPagina(const OfertasPage());
                      },

                      child: categoria(Icons.local_offer, 'Ofertas'),
                    ),

                    GestureDetector(
                      onTap: () {
                        navegarAPagina(const FavoritosPage());
                      },

                      child: categoria(Icons.favorite, 'Favoritos'),
                    ),

                    GestureDetector(
                      onTap: () {
                        navegarAPagina(const PerfilPage());
                      },

                      child: categoria(Icons.person, 'Perfil'),
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                // ====================================================
                // PRODUCTOS DESTACADOS
                // ====================================================
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      'Productos destacados',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: cafeOscuro,
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),

                      decoration: BoxDecoration(
                        color: doradoClaro.withValues(alpha: 0.45),
                        borderRadius: BorderRadius.circular(15),
                      ),

                      child: const Text(
                        '✨ Especiales',
                        style: TextStyle(
                          color: cafeOscuro,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Expanded(
                      child: producto(
                        'Postre de capuchino',
                        '\$25.000',
                        Icons.coffee,
                        0,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Expanded(
                      child: producto(
                        'Postre de mora',
                        '\$35.000',
                        Icons.cake,
                        1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      navegarAPagina(const ProductosPage());
                    },

                    icon: const Icon(Icons.shopping_bag_outlined),

                    label: const Text('Ver todos los productos'),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: cafe,

                      side: const BorderSide(color: dorado, width: 1.5),

                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 10),
              ],
            ],
          ),
        ),
      ),

      // ============================================================
      // BARRA INFERIOR
      // ============================================================
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,

        backgroundColor: cremaClara,

        selectedItemColor: cafe,

        unselectedItemColor: cafeClaro,

        type: BottomNavigationBarType.fixed,

        elevation: 12,

        onTap: (index) {
          switch (index) {
            case 0:
              break;

            case 1:
              navegarAPagina(const FavoritosPage());
              break;

            case 2:
              navegarAPagina(const CarritoPage());
              break;

            case 3:
              navegarAPagina(const PerfilPage());
              break;
          }
        },

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            activeIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }

  // ================================================================
  // CATEGORÍA
  // ================================================================

  Widget categoria(IconData icono, String nombre) {
    return SizedBox(
      width: 70,

      child: Column(
        children: [
          Container(
            width: 62,
            height: 62,

            decoration: BoxDecoration(
              color: cremaClara,

              borderRadius: BorderRadius.circular(18),

              border: Border.all(color: doradoClaro, width: 1),

              boxShadow: [
                BoxShadow(
                  color: cafeOscuro.withValues(alpha: 0.06),
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),

            child: Icon(icono, color: cafe, size: 30),
          ),

          const SizedBox(height: 7),

          Text(
            nombre,

            textAlign: TextAlign.center,

            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: cafeOscuro,
            ),
          ),
        ],
      ),
    );
  }

  // ================================================================
  // PRODUCTO DESTACADO
  // ================================================================

  Widget producto(String nombre, String precio, IconData icono, int index) {
    return GestureDetector(
      onTap: () {
        final productoSeleccionado = productos.firstWhere(
          (producto) => producto['index'] == index,
        );

        navegarAPagina(DetalleProductoPage(producto: productoSeleccionado));
      },

      child: Container(
        padding: const EdgeInsets.all(13),

        decoration: BoxDecoration(
          color: cremaClara,

          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: cafeOscuro.withValues(alpha: 0.08),
              blurRadius: 9,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Stack(
              children: [
                Container(
                  height: 120,
                  width: double.infinity,

                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [doradoClaro.withValues(alpha: 0.35), crema],

                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),

                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Icon(icono, size: 58, color: cafe),
                ),

                Positioned(
                  top: 8,
                  right: 8,

                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: dorado,
                      borderRadius: BorderRadius.circular(12),
                    ),

                    child: const Text('⭐', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              nombre,

              maxLines: 2,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: cafeOscuro,
              ),
            ),

            const SizedBox(height: 6),

            Text(
              precio,

              style: const TextStyle(
                color: dorado,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 9),

            Row(
              children: [
                const Icon(
                  Icons.visibility_outlined,
                  size: 16,
                  color: cafeClaro,
                ),

                const SizedBox(width: 5),

                const Text(
                  'Ver producto',
                  style: TextStyle(
                    color: cafe,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const Spacer(),

                const Icon(Icons.arrow_forward_ios, size: 13, color: cafeClaro),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
