import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../widgets/menu/menu_header.dart';
import '../../widgets/menu/menu_search.dart';
import '../../widgets/menu/menu_categorias.dart';
import '../../widgets/menu/menu_products.dart';
import '../../widgets/menu/menu_grid.dart';
import '../../models/product_model.dart';
import '../../models/categoria_model.dart';
import '../../services/product_service.dart';
import '../../providers/language_provider.dart';

class MenuScreen extends StatefulWidget {
  const MenuScreen({super.key});

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategory = 0;
  int _selectedBottomItem = 0;
  String _busqueda = '';
  List<Categoria> _categorias = [];

  late Future<List<Product>> _futureProductos;

  @override
  void initState() {
    super.initState();
    _futureProductos = ProductService.getProductos();
  }

  void _cambiarCategoria(int index) {
    setState(() {
      _selectedCategory = index;
    });
  }

  void _cambiarPagina(int index) {
    setState(() {
      _selectedBottomItem = index;
    });
  }

  List<Product> _filtrarDestacados(List<Product> productos) {
    var lista = _filtrarPorBusqueda(productos);

    if (_selectedCategory != 0 && _categorias.isNotEmpty) {
      final categoriaId = _categorias[_selectedCategory - 1].id;

      lista = lista
          .where((p) => p.categoria == categoriaId)
          .toList();
    }

    return lista;
  }

  List<Product> _filtrarPorBusqueda(List<Product> productos) {
    if (_busqueda.isEmpty) {
      return productos;
    }

    return productos
        .where(
          (p) => p.nombre
              .toLowerCase()
              .contains(_busqueda.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return Scaffold(
      backgroundColor: AppColors.crema,
      body: Stack(
        children: [
          // FONDO DECORATIVO
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/img/patron_santacruz.png',
                fit: BoxFit.cover,
              ),
            ),
          ),

          // CONTENIDO PRINCIPAL
          SafeArea(
            child: Column(
              children: [
                // HEADER + BUSCADOR
                SizedBox(
                  height: 265,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: MenuHeader(),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 15,
                        right: 15,
                        child: MenuSearch(
                          onChanged: (texto) {
                            setState(() {
                              _busqueda = texto;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                // CONTENIDO SCROLL
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        // CATEGORÍAS
                        MenuCategories(
                          selectedCategory: _selectedCategory,
                          onCategorySelected: _cambiarCategoria,
                          onCategoriasLoaded: (lista) {
                            setState(() {
                              _categorias = lista;
                            });
                          },
                        ),

                        const SizedBox(height: 18),

                        // PRODUCTOS
                        FutureBuilder<List<Product>>(
                          future: _futureProductos,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.caramelo,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                    style: const TextStyle(
                                      color: AppColors.textoCafe,
                                    ),
                                  ),
                                ),
                              );
                            }

                            final todosLosProductos =
                                snapshot.data ?? [];

                            if (_busqueda.isNotEmpty) {
                              final resultados =
                                  _filtrarPorBusqueda(
                                todosLosProductos,
                              );

                              return MenuGrid(
                                products: resultados,
                              );
                            }

                            final destacados =
                                _filtrarDestacados(
                              todosLosProductos,
                            );

                            final todoElMenu =
                                todosLosProductos;

                            return Column(
                              children: [
                                MenuProducts(
                                  products: destacados,
                                ),

                                const SizedBox(height: 24),

                                // TÍTULO TODO EL MENU
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      lang.t('todo_el_menu'),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textoCafe,
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 12),

                                MenuGrid(
                                  products: todoElMenu,
                                ),
                              ],
                            );
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // MENU INFERIOR
      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedBottomItem,
        onItemSelected: _cambiarPagina,
      ),
    );
  }
}