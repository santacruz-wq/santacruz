import 'package:flutter/material.dart';

import '../../widgets/global/bottom_menu.dart';
import '../../widgets/menu/menu_header.dart';
import '../../widgets/menu/menu_search.dart';
import '../../widgets/menu/menu_categorias.dart';
import '../../widgets/menu/menu_products.dart';
import '../../models/product_model.dart';
import '../../models/categoria_model.dart';
import '../../services/product_service.dart';

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

  List<Product> _filtrar(List<Product> productos) {
    var lista = productos;

    // Filtro por categoría (index 0 = Destacados = todos)
    if (_selectedCategory != 0 && _categorias.isNotEmpty) {
      final categoriaId = _categorias[_selectedCategory - 1].id;
      lista = lista.where((p) => p.categoria == categoriaId).toList();
    }

    // Filtro por texto del buscador
    if (_busqueda.isNotEmpty) {
      lista = lista
          .where((p) =>
              p.nombre.toLowerCase().contains(_busqueda.toLowerCase()))
          .toList();
    }

    return lista;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF1DC),

      body: SafeArea(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                const MenuHeader(),
                Positioned(
                  bottom: -25,
                  left: 0,
                  right: 0,
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

            const SizedBox(height: 35),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
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

                    FutureBuilder<List<Product>>(
                      future: _futureProductos,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: Text('Error: ${snapshot.error}'),
                            ),
                          );
                        }

                        final productos = _filtrar(snapshot.data ?? []);

                        return MenuProducts(products: productos);
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

      bottomNavigationBar: BottomMenu(
        currentIndex: _selectedBottomItem,
        onItemSelected: _cambiarPagina,
      ),
    );
  }
}