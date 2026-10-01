import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../core/navigation/menu_navigation.dart';
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
  final bool showBottomBar;

  const MenuScreen({
    super.key,
    this.showBottomBar = true,
  });

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedCategory = 0;
  String _busqueda = '';
  List<Categoria> _categorias = [];

  late Future<List<ProductModel>> _futureProductos;

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

  List<ProductModel> _filtrarDestacados(
    List<ProductModel> productos,
  ) {
    var lista = _filtrarPorBusqueda(productos);

    if (_selectedCategory != 0 &&
        _categorias.isNotEmpty) {
      final categoriaId =
          _categorias[_selectedCategory - 1].id;

      lista = lista
          .where(
            (p) => p.categoriaId == categoriaId,
          )
          .toList();
    }

    return lista;
  }

  List<ProductModel> _filtrarPorBusqueda(
    List<ProductModel> productos,
  ) {
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
          Positioned.fill(
            child: Opacity(
              opacity: 0.35,
              child: Image.asset(
                'assets/img/imagen_fondo.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              SizedBox(
                height: 320,
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
              Expanded(
                child: SafeArea(
                  top: false,
                  child: SingleChildScrollView(
                    physics:
                        const BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        MenuCategories(
                          selectedCategory:
                              _selectedCategory,
                          onCategorySelected:
                              _cambiarCategoria,
                          onCategoriasLoaded:
                              (lista) {
                            setState(() {
                              _categorias = lista;
                            });
                          },
                        ),
                        const SizedBox(height: 18),
                        FutureBuilder<
                            List<ProductModel>>(
                          future: _futureProductos,
                          builder:
                              (context, snapshot) {
                            if (snapshot
                                    .connectionState ==
                                ConnectionState.waiting) {
                              return const Padding(
                                padding:
                                    EdgeInsets.symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child:
                                      CircularProgressIndicator(
                                    color:
                                        AppColors.caramelo,
                                  ),
                                ),
                              );
                            }

                            if (snapshot.hasError) {
                              return Padding(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  vertical: 40,
                                ),
                                child: Center(
                                  child: Text(
                                    'Error: ${snapshot.error}',
                                  ),
                                ),
                              );
                            }

                            final todos =
                                snapshot.data ?? [];

                            if (_busqueda.isNotEmpty) {
                              return MenuGrid(
                                products:
                                    _filtrarPorBusqueda(
                                  todos,
                                ),
                              );
                            }

                            return Column(
                              children: [
                                MenuProducts(
                                  products:
                                      _filtrarDestacados(
                                    todos,
                                  ),
                                ),
                                const SizedBox(
                                  height: 24,
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Align(
                                    alignment:
                                        Alignment
                                            .centerLeft,
                                    child: Text(
                                      lang.t(
                                        'todo_el_menu',
                                      ),
                                      style:
                                          const TextStyle(
                                        fontSize: 16,
                                        fontWeight:
                                            FontWeight
                                                .bold,
                                        color:
                                            AppColors
                                                .textoCafe,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                MenuGrid(
                                  products: todos,
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
              ),
            ],
          ),
        ],
      ),
      // MENÚ INFERIOR
      bottomNavigationBar:
          widget.showBottomBar
              ? BottomMenu(
                  currentIndex: 0,
                  onItemSelected: (i) =>
                      navegarDesdeMenu(
                    context,
                    i,
                    0,
                  ),
                )
              : null,
    );
  }
}
