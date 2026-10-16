import 'package:flutter/material.dart';

import '../../core/config/app_colors.dart';
import '../../core/navigation/menu_navigation.dart';
import '../../models/categoria_model.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../../widgets/global/bottom_menu.dart';
import '../../widgets/menu/menu_categorias.dart';
import 'chat_screen.dart';
import 'widgets/menu_productos_section.dart';
import 'widgets/menu_top_section.dart';

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

  void _abrirChat() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.crema,
      body: Stack(
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Opacity(
                opacity: 0.35,
                child: Image.asset(
                  'assets/img/imagen_fondo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Column(
            children: [
              MenuTopSection(
                onBusquedaChanged: (texto) {
                  setState(() {
                    _busqueda = texto;
                  });
                },
              ),
              const SizedBox(height: 15),
              Expanded(
                child: SafeArea(
                  top: false,
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
                        MenuProductosSection(
                          futureProductos: _futureProductos,
                          busqueda: _busqueda,
                          selectedCategory: _selectedCategory,
                          categorias: _categorias,
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
      floatingActionButton: FloatingActionButton(
        onPressed: _abrirChat,
        backgroundColor: AppColors.cafeMedio,
        foregroundColor: Colors.white,
        elevation: 6,
        tooltip: 'Chat',
        child: Container(
          width: 42,
          height: 42,
          padding: const EdgeInsets.all(3),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/img/santacruz_de_la_plazuela-removebg-preview.png',
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) {
                return const Icon(
                  Icons.chat_rounded,
                  color: Color(0xFF6F4E37),
                  size: 26,
                );
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: widget.showBottomBar
          ? BottomMenu(
              currentIndex: 0,
              onItemSelected: (i) {
                navegarDesdeMenu(context, i, 0);
              },
            )
          : null,
    );
  }
}