import 'package:flutter/material.dart';

import 'pages/productos_page.dart';
import 'pages/favoritos_page.dart';
import 'pages/carrito_page.dart';
import 'pages/perfil_page.dart';
import 'pages/ofertas_page.dart';
import 'pages/detalle_producto_page.dart';
import 'idioma_data.dart';
import 'carrito_data.dart';

void main() {
  runApp(const SantaCruzApp());
}

class SantaCruzApp extends StatelessWidget {
  const SantaCruzApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, _) {
        return ValueListenableBuilder<bool>(
          valueListenable: IdiomaData.modoOscuro,
          builder: (context, oscuro, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Santa Cruz',
              locale: locale,

              // ========================================================
              // TEMA CLARO
              // ========================================================
              theme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Arial',
                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6F4E37),
                  brightness: Brightness.light,
                ),
                scaffoldBackgroundColor: const Color(0xFFFFFBF5),
              ),

              // ========================================================
              // TEMA OSCURO
              // ========================================================
              darkTheme: ThemeData(
                useMaterial3: true,
                fontFamily: 'Arial',
                brightness: Brightness.dark,

                colorScheme: ColorScheme.fromSeed(
                  seedColor: const Color(0xFF6F4E37),
                  brightness: Brightness.dark,
                ),

                scaffoldBackgroundColor: const Color(0xFF1E1714),

                appBarTheme: const AppBarTheme(
                  backgroundColor: Color(0xFF1E1714),
                  foregroundColor: Color(0xFFFFF8E7),
                ),

                cardTheme: const CardThemeData(color: Color(0xFF2B211D)),

                navigationBarTheme: const NavigationBarThemeData(
                  backgroundColor: Color(0xFF2B211D),
                  indicatorColor: Color(0xFF6F4E37),
                ),

                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                  fillColor: Color(0xFF2B211D),
                ),

                dialogTheme: const DialogThemeData(
                  backgroundColor: Color(0xFF2B211D),
                ),
              ),

              themeMode: oscuro ? ThemeMode.dark : ThemeMode.light,

              home: const InicioPage(),
            );
          },
        );
      },
    );
  }
}

// ====================================================================
// INICIO
// ====================================================================
    class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

   class _InicioPageState extends State<InicioPage>
    with TickerProviderStateMixin {

  // ==================================================================
  // COLORES
  // ==================================================================

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);

  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);

  static const Color dorado = Color(0xFFDDB447);
  static const Color doradoClaro = Color(0xFFF3D27A);

  // ==================================================================
  // CONTROLADORES
  // ==================================================================

  final TextEditingController buscadorController = TextEditingController();

  String textoBusqueda = '';

  int paginaActual = 0;

        // Controlador para la animación de categorías
late AnimationController categoriasController;

          // ==================================================================
// ANIMACIÓN DEL TEXTO DE BIENVENIDA
// ==================================================================

late AnimationController textoBienvenidaController;

String textoBienvenida = '';

   void _cambioIdioma() {
  if (!mounted) {
    return;
  }

  textoBienvenidaController.reset();
  textoBienvenidaController.repeat();
}

  // ==================================================================
  // CATEGORÍAS
  // ==================================================================

  final List<Map<String, dynamic>> categorias = [
    {'nombre': 'Tortas', 'nombreEn': 'Cakes', 'icono': Icons.cake},
    {'nombre': 'Postres', 'nombreEn': 'Desserts', 'icono': Icons.icecream},
    {'nombre': 'Brownies', 'nombreEn': 'Brownies', 'icono': Icons.cookie},
    {'nombre': 'Café', 'nombreEn': 'Coffee', 'icono': Icons.coffee},
  ];

  // ==================================================================
  // PRODUCTOS
  // ==================================================================

  final List<Map<String, dynamic>> productos = [
    {
      'nombre': 'Postre de capuchino',
      'nombreEn': 'Cappuccino Dessert',
      'precio': '\$15.000',
      'descripcion':
          'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café. Perfecto para disfrutar en cualquier momento.',
      'descripcionEn':
          'Delicious cappuccino dessert made with a smooth cream and an intense coffee flavor. Perfect to enjoy at any time.',
      'icono': Icons.coffee,
    },
    {
      'nombre': 'Postre de mora',
      'nombreEn': 'Blackberry Dessert',
      'precio': '\$11.000',
      'descripcion':
          'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora. Una combinación dulce y refrescante.',
      'descripcionEn':
          'Delicious blackberry dessert made with a creamy mixture and the delicious flavor of blackberry. A sweet and refreshing combination.',
      'icono': Icons.cake,
    },
    {
      'nombre': 'Torta de tres leches',
      'nombreEn': 'Tres Leches Cake',
      'precio': '\$25.000',
      'descripcion':
          'Suave y deliciosa torta de tres leches, preparada para ofrecer una textura húmeda y cremosa con un sabor irresistible.',
      'descripcionEn':
          'Soft and delicious tres leches cake, prepared with a moist and creamy texture and an irresistible flavor.',
      'icono': Icons.cake,
    },
    {
      'nombre': 'Torta de café',
      'nombreEn': 'Coffee Cake',
      'precio': '\$30.000',
      'descripcion':
          'Deliciosa torta de café con un suave sabor y aroma a café. Perfecta para acompañar una bebida caliente.',
      'descripcionEn':
          'Delicious coffee cake with a smooth coffee flavor and aroma. Perfect to enjoy with a hot drink.',
      'icono': Icons.coffee,
    },
    {
      'nombre': 'Cheesecake de fresa',
      'nombreEn': 'Strawberry Cheesecake',
      'precio': '\$40.000',
      'descripcion':
          'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
      'descripcionEn':
          'Delicious strawberry cheesecake with a creamy texture and a sweet strawberry topping.',
      'icono': Icons.cake,
    },
    {
      'nombre': 'Brownie de chocolate',
      'nombreEn': 'Chocolate Brownie',
      'precio': '\$22.000',
      'descripcion':
          'Suave y delicioso brownie de chocolate, preparado con un intenso sabor a chocolate y una textura irresistible.',
      'descripcionEn':
          'Soft and delicious chocolate brownie with an intense chocolate flavor and an irresistible texture.',
      'icono': Icons.cookie,
    },
    {
      'nombre': 'Cupcake de vainilla',
      'nombreEn': 'Vanilla Cupcake',
      'precio': '\$15.000',
      'descripcion':
          'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
      'descripcionEn':
          'Fluffy vanilla cupcake with a smooth cream and a delicious sweet touch.',
      'icono': Icons.cake,
    },
    {
      'nombre': 'Tarta de limón',
      'nombreEn': 'Lemon Tart',
      'precio': '\$28.000',
      'descripcion':
          'Deliciosa tarta de limón con una combinación equilibrada entre el sabor dulce y el toque refrescante del limón.',
      'descripcionEn':
          'Delicious lemon tart with a balanced combination of sweetness and a refreshing touch of lemon.',
      'icono': Icons.pie_chart,
    },
  ];

  // ==================================================================
  // NORMALIZAR TEXTO
  // ==================================================================

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

  // ==================================================================
  // PRODUCTOS FILTRADOS
  // ==================================================================

  List<Map<String, dynamic>> get productosFiltrados {
    if (textoBusqueda.trim().isEmpty) {
      return productos;
    }

    final busqueda = normalizarTexto(textoBusqueda);

    return productos.where((producto) {
      final nombre = normalizarTexto(producto['nombre']);
      final nombreEn = normalizarTexto(producto['nombreEn']);

      return nombre.contains(busqueda) || nombreEn.contains(busqueda);
    }).toList();
  }

           // ==================================================================
// ANIMACIÓN LETRA POR LETRA
// ==================================================================

@override
void initState() {
  super.initState();

  IdiomaData.idioma.addListener(_cambioIdioma);
   
    // ================================================================
  // ANIMACIÓN DE CATEGORÍAS
  // ================================================================

  categoriasController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  categoriasController.forward();

  textoBienvenidaController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 10000),
  );

  textoBienvenidaController.addListener(() {
    if (!mounted) {
      return;
    }

    final textoCompleto = IdiomaData.texto('bienvenido');

    final progreso = textoBienvenidaController.value;

    int cantidadVisible;

    if (progreso < 0.65) {
      cantidadVisible =
          (textoCompleto.length * (progreso / 0.65)).floor();
    } else {
      cantidadVisible =
          (textoCompleto.length *
                  (1 - ((progreso - 0.65) / 0.35)))
              .floor();
    }

    cantidadVisible =
        cantidadVisible.clamp(0, textoCompleto.length);

    setState(() {
      textoBienvenida =
          textoCompleto.substring(0, cantidadVisible);
    });
  });

  textoBienvenidaController.repeat();
}  

  // ==================================================================
  // BUILD
  // ==================================================================

  @override
  Widget build(BuildContext context) {
    final es = IdiomaData.idioma.value.languageCode == 'es';

    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    // ==================================================================
    // COLORES DINÁMICOS
    // ==================================================================

    final fondo = esOscuro ? const Color(0xFF1E1714) : cremaClara;

    final superficie = esOscuro ? const Color(0xFF2B211D) : Colors.white;

    final superficieSuave = esOscuro ? const Color(0xFF3A2B25) : crema;

    final textoPrincipal = esOscuro ? const Color(0xFFFFF8E7) : cafeOscuro;

    final textoSecundario = esOscuro ? const Color(0xFFD7C5B8) : cafeClaro;

    return Scaffold(
      backgroundColor: fondo,

      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ==========================================================
            // ENCABEZADO
            // ==========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),

                child: Row(
                  children: [
                    // Icono
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [cafeOscuro, cafe],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: cafe.withValues(alpha: 0.20),
                            blurRadius: 12,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.coffee,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Santa Cruz',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: textoPrincipal,
                              letterSpacing: -0.5,
                            ),
                          ),

                          const SizedBox(height: 2),

                          Text(
                            es
                                ? 'Delicias hechas con amor'
                                : 'Delicious treats made with love',
                            style: TextStyle(
                              fontSize: 13,
                              color: textoSecundario,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Pequeño detalle decorativo
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: superficie,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(Icons.favorite_border, color: cafe, size: 22),
                    ),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // BUSCADOR
            // ==========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 18),

                child: Container(
                  decoration: BoxDecoration(
                    color: superficie,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),

                  child: TextField(
                    controller: buscadorController,

                    onChanged: (valor) {
                      setState(() {
                        textoBusqueda = valor;
                      });
                    },

                    decoration: InputDecoration(
                      hintText: es
                          ? '¿Qué quieres encontrar?'
                          : 'What are you looking for?',

                      hintStyle: TextStyle(
                        color: textoSecundario,
                        fontSize: 14,
                      ),

                      prefixIcon: Container(
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: superficieSuave,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.search, color: cafe, size: 21),
                      ),

                      suffixIcon: textoBusqueda.isNotEmpty
                          ? IconButton(
                              icon: Icon(Icons.clear, color: textoSecundario),
                              onPressed: () {
                                buscadorController.clear();

                                setState(() {
                                  textoBusqueda = '';
                                });
                              },
                            )
                          : null,

                      filled: true,
                      fillColor: Colors.transparent,

                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 8,
                      ),

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ==========================================================
            // RESULTADOS DE BÚSQUEDA
            // ==========================================================
            if (textoBusqueda.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 14),

                  child: Container(
                    padding: const EdgeInsets.all(15),

                    decoration: BoxDecoration(
                      color: superficieSuave,
                      borderRadius: BorderRadius.circular(17),
                    ),

                    child: productosFiltrados.isEmpty
                        ? Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: superficie,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.search_off,
                                  color: textoSecundario,
                                  size: 20,
                                ),
                              ),

                              const SizedBox(width: 10),

                              Expanded(
                                child: Text(
                                  es
                                      ? 'No encontramos productos.'
                                      : 'No products found.',
                                  style: TextStyle(
                                    color: textoPrincipal,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : Row(
                            children: [
                              const Icon(
                                Icons.check_circle_outline,
                                color: cafe,
                                size: 21,
                              ),

                              const SizedBox(width: 9),

                              Text(
                                es
                                    ? '${productosFiltrados.length} producto(s) encontrado(s)'
                                    : '${productosFiltrados.length} product(s) found',
                                style: TextStyle(
                                  color: textoPrincipal,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

            // ==========================================================
            // TARJETA DE BIENVENIDA
            // ==========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),

                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),

                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [cafeOscuro, cafe, cafeClaro],
                    ),

                    borderRadius: BorderRadius.circular(24),

                    boxShadow: [
                      BoxShadow(
                        color: cafe.withValues(alpha: 0.20),
                        blurRadius: 16,
                        offset: const Offset(0, 7),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),

                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),

                              child: Text(
                                es ? 'SABORES ESPECIALES' : 'SPECIAL FLAVORS',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.7,
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),

                             Text(
  textoBienvenida,
  style: const TextStyle(
    color: Colors.white,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  ),
),

                            const SizedBox(height: 7),

                            Text(
                              es
                                  ? 'Descubre nuestros deliciosos postres y tortas.'
                                  : 'Discover our delicious desserts and cakes.',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                height: 1.4,
                              ),
                            ),

                            const SizedBox(height: 17),

                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ProductosPage(),
                                  ),
                                );
                              },

                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: cafeOscuro,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),

                              child: Text(
                                es ? 'Ver productos' : 'View products',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cake,
                          color: Colors.white,
                          size: 42,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ==========================================================
            // CATEGORÍAS
            // ==========================================================
            SliverToBoxAdapter(
  child: Padding(
    padding: const EdgeInsets.fromLTRB(20, 18, 20, 4),
    child: Text(
      IdiomaData.texto('categorias'),
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: cafeOscuro,
        fontFamily: 'Arial',
      ),
    ),
  ),
),

SliverToBoxAdapter(
  child: SizedBox(
    height: 132,

    child: ListView.builder(
      scrollDirection: Axis.horizontal,

      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),

      itemCount: categorias.length,

      itemBuilder: (context, index) {
        final inicio = index * 0.2;

        final animacion = CurvedAnimation(
          parent: categoriasController,
          curve: Interval(
            inicio,
            (inicio + 0.6).clamp(0.0, 1.0),
            curve: Curves.easeOutCubic,
          ),
        );

        return FadeTransition(
          opacity: animacion,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.15),
              end: Offset.zero,
            ).animate(animacion),

            child: ScaleTransition(
              scale: Tween<double>(
                begin: 0.92,
                end: 1.0,
              ).animate(animacion),

              child: categoria(
                categorias[index],
                es,
              ),
            ),
          ),
        );
      },
    ),
  ),
),

                 
            // ==========================================================
            // PRODUCTOS DESTACADOS
            // ==========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),

                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        textoBusqueda.isNotEmpty
                            ? (es ? 'Resultados' : 'Results')
                            : (es
                                  ? 'Productos destacados'
                                  : 'Featured products'),
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                          color: textoPrincipal,
                        ),
                      ),
                    ),

                    if (textoBusqueda.isEmpty)
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const ProductosPage(),
                            ),
                          );
                        },
                        child: Text(
                          es ? 'Ver todos' : 'See all',
                          style: const TextStyle(
                            color: cafe,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // ==========================================================
            // PRODUCTOS
            // ==========================================================
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),

              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final productoActual = productosFiltrados[index];

                  return producto(productoActual, es);
                }, childCount: productosFiltrados.length),

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 0.72,
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ==========================================================
            // OFERTA ESPECIAL
            // ==========================================================
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),

                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const OfertasPage()),
                    );
                  },

                  child: Container(
                    padding: const EdgeInsets.all(18),

                    decoration: BoxDecoration(
                      color: superficie,
                      borderRadius: BorderRadius.circular(20),

                      border: Border.all(
                        color: doradoClaro.withValues(alpha: 0.45),
                      ),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        Container(
                          width: 52,
                          height: 52,

                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [doradoClaro, Color(0xFFE7C45F)],
                            ),
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.local_offer,
                            color: cafeOscuro,
                            size: 25,
                          ),
                        ),

                        const SizedBox(width: 14),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                es ? 'Ofertas especiales' : 'Special offers',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: textoPrincipal,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                es
                                    ? 'Descubre promociones y productos especiales.'
                                    : 'Discover promotions and special products.',
                                style: TextStyle(
                                  color: textoSecundario,
                                  fontSize: 13,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: 34,
                          height: 34,

                          decoration: BoxDecoration(
                            color: superficieSuave,
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: cafe,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 30)),
          ],
        ),
      ),

      // ================================================================
      // BARRA DE NAVEGACIÓN
      // ================================================================
      bottomNavigationBar: _barraNavegacion(context, es, esOscuro),
    );
  }

  // ==================================================================
  // CATEGORÍA
  // ==================================================================

  Widget categoria(Map<String, dynamic> categoria, bool es) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    final superficie = esOscuro ? const Color(0xFF2B211D) : Colors.white;

    final superficieIcono = esOscuro ? const Color(0xFF3A2B25) : crema;

    final textoPrincipal = esOscuro ? const Color(0xFFFFF8E7) : cafeOscuro;

    return Container(
      width: 105,

      margin: const EdgeInsets.only(right: 12),

      decoration: BoxDecoration(
        color: superficie,

        borderRadius: BorderRadius.circular(20),

        border: Border.all(
          color: esOscuro
              ? Colors.white.withValues(alpha: 0.04)
              : cafeClaro.withValues(alpha: 0.08),
        ),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: esOscuro ? 0.18 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Container(
            width: 52,
            height: 52,

            decoration: BoxDecoration(
              color: superficieIcono,
              shape: BoxShape.circle,
            ),

            child: Icon(categoria['icono'], color: cafe, size: 27),
          ),

          const SizedBox(height: 9),

          Text(
            es ? categoria['nombre'] : categoria['nombreEn'],

            textAlign: TextAlign.center,

            style: TextStyle(
              color: textoPrincipal,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  // ==================================================================
  // PRODUCTO
  // ==================================================================

  Widget producto(Map<String, dynamic> producto, bool es) {
    final esOscuro = Theme.of(context).brightness == Brightness.dark;

    final superficie = esOscuro ? const Color(0xFF2B211D) : Colors.white;

    final superficieSuave = esOscuro ? const Color(0xFF3A2B25) : crema;

    final textoPrincipal = esOscuro ? const Color(0xFFFFF8E7) : cafeOscuro;

    final textoSecundario = esOscuro ? const Color(0xFFD7C5B8) : cafeClaro;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetalleProductoPage(producto: producto),
          ),
        );
      },

      child: Container(
        decoration: BoxDecoration(
          color: superficie,

          borderRadius: BorderRadius.circular(20),

          border: Border.all(
            color: esOscuro
                ? Colors.white.withValues(alpha: 0.04)
                : cafeClaro.withValues(alpha: 0.07),
          ),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: esOscuro ? 0.18 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.all(12),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // --------------------------------------------------------
              // IMAGEN / ICONO
              // --------------------------------------------------------
              Expanded(
                child: Container(
                  width: double.infinity,

                  decoration: BoxDecoration(
                    color: superficieSuave,
                    borderRadius: BorderRadius.circular(16),
                  ),

                  child: Stack(
                    children: [
                      Center(
                        child: Container(
                          width: 78,
                          height: 78,

                          decoration: BoxDecoration(
                            color: superficie,
                            shape: BoxShape.circle,
                          ),

                          child: Icon(producto['icono'], size: 42, color: cafe),
                        ),
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
                            color: superficie,
                            borderRadius: BorderRadius.circular(10),
                          ),

                          child: const Icon(
                            Icons.favorite_border,
                            size: 16,
                            color: cafe,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // --------------------------------------------------------
              // NOMBRE
              // --------------------------------------------------------
              Text(
                es ? producto['nombre'] : producto['nombreEn'],

                maxLines: 2,
                overflow: TextOverflow.ellipsis,

                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: textoPrincipal,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 7),

              // --------------------------------------------------------
              // PRECIO
              // --------------------------------------------------------
              Row(
                children: [
                  Expanded(
                    child: Text(
                      producto['precio'],
                      style: const TextStyle(
                        color: dorado,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 7,
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      color: superficieSuave,
                      borderRadius: BorderRadius.circular(9),
                    ),

                    child: Icon(Icons.arrow_forward, color: cafe, size: 16),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                es ? 'Ver detalle' : 'View details',
                style: TextStyle(color: textoSecundario, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================================================================
  // BARRA DE NAVEGACIÓN
  // ==================================================================

  Widget _barraNavegacion(BuildContext context, bool es, bool esOscuro) {
    return NavigationBar(
      selectedIndex: paginaActual,

      backgroundColor: esOscuro ? const Color(0xFF2B211D) : Colors.white,

      indicatorColor: esOscuro ? cafe : doradoClaro.withValues(alpha: 0.55),

      onDestinationSelected: (index) {
        setState(() {
          paginaActual = index;
        });

        // --------------------------------------------------------------
        // INICIO
        // --------------------------------------------------------------

        if (index == 0) {
          return;
        }

        // --------------------------------------------------------------
        // FAVORITOS
        // --------------------------------------------------------------

        if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const FavoritosPage()),
          ).then((_) {
            if (mounted) {
              setState(() {});
            }
          });

          return;
        }

        // --------------------------------------------------------------
        // CARRITO
        // --------------------------------------------------------------

        if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CarritoPage()),
          ).then((_) {
            if (mounted) {
              setState(() {});
            }
          });

          return;
        }

        // --------------------------------------------------------------
        // PERFIL
        // --------------------------------------------------------------

        if (index == 3) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PerfilPage()),
          ).then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      },

      destinations: [
        // ==============================================================
        // INICIO
        // ==============================================================
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: es ? 'Inicio' : 'Home',
        ),

        // ==============================================================
        // FAVORITOS
        // ==============================================================
        NavigationDestination(
          icon: const Icon(Icons.favorite_border),
          selectedIcon: const Icon(Icons.favorite),
          label: es ? 'Favoritos' : 'Favorites',
        ),

        // ==============================================================
        // CARRITO
        // ==============================================================
        NavigationDestination(
          icon: ValueListenableBuilder<int>(
            valueListenable: CarritoData.cantidadProductos,

            builder: (context, cantidad, _) {
              return Badge(
                isLabelVisible: cantidad > 0,

                label: Text(cantidad.toString()),

                child: const Icon(Icons.shopping_cart_outlined),
              );
            },
          ),

          selectedIcon: const Icon(Icons.shopping_cart),

          label: es ? 'Carrito' : 'Cart',
        ),

        // ==============================================================
        // PERFIL
        // ==============================================================
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: es ? 'Perfil' : 'Profile',
        ),
      ],
    );
  }

  // ==================================================================
  // DISPOSE
  // ==================================================================

  @override
  void dispose() {
    buscadorController.dispose();
     IdiomaData.idioma.removeListener(_cambioIdioma);
    textoBienvenidaController.dispose();
    super.dispose();
  }
}
