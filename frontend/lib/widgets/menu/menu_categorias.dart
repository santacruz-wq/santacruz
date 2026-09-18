import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_colors.dart';
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
      height: 44,
      child: FutureBuilder<List<Categoria>>(
        future: _futureCategorias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.caramelo,
                ),
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return const SizedBox.shrink();
          }

          final nombresOriginales =
              snapshot.data!.map((c) => c.nombre).toList();

          return FutureBuilder<List<String>>(
            key: ValueKey(lang.idiomaCodigo),
            future: TranslationService.traducirLista(
              nombresOriginales,
              lang.idiomaCodigo,
            ),
            builder: (context, snapshotTraducido) {
              final nombresTraducidos =
                  snapshotTraducido.data ?? nombresOriginales;

              final categorias = [
                lang.t('destacados'),
                ...nombresTraducidos
              ];

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 18),
                itemCount: categorias.length,
                itemBuilder: (context, index) {
                  final bool selected = widget.selectedCategory == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 10),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: () => widget.onCategorySelected(index),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.caramelo
                                : AppColors.cremaClaro,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: selected
                                  ? AppColors.caramelo
                                  : AppColors.carameloClaro.withOpacity(0.4),
                              width: 1.2,
                            ),
                            boxShadow: selected
                                ? [
                                    BoxShadow(
                                      color: AppColors.caramelo.withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Center(
                            child: Text(
                              categorias[index],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: selected
                                    ? Colors.white
                                    : AppColors.textoCafe,
                              ),
                            ),
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