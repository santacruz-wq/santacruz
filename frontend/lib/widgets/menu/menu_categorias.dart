import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/categoria_service.dart';
import '../../services/translation_service.dart';
import '../../models/categoria_model.dart';
import '../../providers/language_provider.dart';

class MenuCategories extends StatefulWidget {
  final int selectedCategory;
  final Function(int) onCategorySelected;
  final Function(List<Categoria>) onCategoriasLoaded;

  const MenuCategories({
    super.key,
    required this.selectedCategory,
    required this.onCategorySelected,
    required this.onCategoriasLoaded,
  });

  @override
  State<MenuCategories> createState() => _MenuCategoriesState();
}

class _MenuCategoriesState extends State<MenuCategories> {
  late Future<List<Categoria>> _futureCategorias;

  @override
  void initState() {
    super.initState();
    _futureCategorias = CategoriaService.getCategorias();
    _futureCategorias.then((lista) {
      widget.onCategoriasLoaded(lista);
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    return SizedBox(
      height: 48,
      child: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final nombresOriginales = snapshot.data!.map((c) => c.nombre).toList();

          return FutureBuilder<List<String>>(
            // key fuerza a que se vuelva a traducir cuando cambia el idioma
            key: ValueKey(lang.idiomaCodigo),
            future: TranslationService.traducirLista(
              nombresOriginales,
              lang.idiomaCodigo,
            ),
            builder: (context, snapshotTraducido) {
              final nombresTraducidos =
                  snapshotTraducido.data ?? nombresOriginales;

              final categorias = [lang.t('destacados'), ...nombresTraducidos];

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final bool selected = widget.selectedCategory == index;

                  return GestureDetector(
                    onTap: () => widget.onCategorySelected(index),
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFF2D09D)
                            : const Color(0xFFEADCC5),
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: Center(
                        child: Text(
                          categorias[index],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}