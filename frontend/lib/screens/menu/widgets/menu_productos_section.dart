
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/config/app_colors.dart';
import '../../../widgets/menu/menu_products.dart';
import '../../../widgets/menu/menu_grid.dart';
import '../../../models/product_model.dart';
import '../../../models/categoria_model.dart';
import '../../../providers/language_provider.dart';
import '../helpers/menu_filtros.dart';

class MenuProductosSection extends StatelessWidget {
  final Future<List<ProductModel>> futureProductos;
  final String busqueda;
  final int selectedCategory;
  final List<Categoria> categorias;

  const MenuProductosSection({
    super.key,
    required this.futureProductos,
    required this.busqueda,
    required this.selectedCategory,
    required this.categorias,
  });

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return FutureBuilder<List<ProductModel>>(
      future: futureProductos,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 40),
            child: Center(
              child: CircularProgressIndicator(
                color: AppColors.caramelo,
              ),
            ),
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

        final todos = snapshot.data ?? [];

        // Filtrar por categoría seleccionada.
        List<ProductModel> productosCategoria = todos;

        if (selectedCategory > 0 &&
            selectedCategory <= categorias.length) {
          final categoriaId = categorias[selectedCategory - 1].id;

          productosCategoria = todos
              .where(
                (p) =>
                    p.categoriaId == categoriaId &&
                    p.visibleMenu,
              )
              .toList();
        }

        // Aplicar búsqueda.
        if (busqueda.isNotEmpty) {
          final resultados = filtrarPorBusqueda(
            productosCategoria,
            busqueda,
          );

          return MenuGrid(products: resultados);
        }

        // Cuando se selecciona una categoría,
        // mostrar todos sus productos, no solamente destacados.
        if (selectedCategory > 0 &&
            selectedCategory <= categorias.length) {
          return MenuGrid(products: productosCategoria);
        }

        // Vista inicial: destacados y todo el menú.
        return Column(
          children: [
            MenuProducts(
              products: filtrarDestacados(
                todos,
                busqueda: busqueda,
                selectedCategory: 0,
                categorias: categorias,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
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
            MenuGrid(products: todos),
          ],
        );
      },
    );
  }
}
