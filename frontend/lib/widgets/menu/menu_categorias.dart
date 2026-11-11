
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/translation_postres.dart';
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

  static const Set<String> _categoriasEstaticas = {
    'Esponjados',
    'Frutas',
    'Postres fríos',
    'Flanes',
    'Tortas',
    'Cafés',
    'Bebidas',
  };

  @override
  void initState() {
    super.initState();

    _futureCategorias = CategoriaService.getCategorias();

    _futureCategorias.then((lista) {
      if (mounted) {
        widget.onCategoriasLoaded(lista);
      }
    });
  }

  Future<List<String>> _obtenerCategoriasTraducidas(
    List<String> nombresOriginales,
    String idioma,
  ) async {
    final nombresTraducidos = List<String>.from(nombresOriginales);

    final indicesGroq = <int>[];
    final categoriasGroq = <String>[];

    for (var i = 0; i < nombresOriginales.length; i++) {
      final nombre = nombresOriginales[i].trim();

      if (_categoriasEstaticas.contains(nombre)) {
        nombresTraducidos[i] = TranslationPostres.obtenerCategoria(
          nombre: nombre,
          idioma: idioma,
        );
      } else if (idioma != 'es') {
        // Las categorías nuevas se traducen mediante Groq.
        indicesGroq.add(i);
        categoriasGroq.add(nombre);
      }
    }

    if (categoriasGroq.isNotEmpty) {
      try {
        final traducidas = await TranslationService.traducirLista(
          categoriasGroq,
          idioma,
        );

        for (var i = 0; i < indicesGroq.length; i++) {
          if (i < traducidas.length) {
            nombresTraducidos[indicesGroq[i]] = traducidas[i];
          }
        }
      } catch (_) {
        // Si Groq falla, se conservan los nombres originales.
      }
    }

    return nombresTraducidos;
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
            future: _obtenerCategoriasTraducidas(
              nombresOriginales,
              lang.idiomaCodigo,
            ),
            builder: (context, snapshotTraducido) {
              final nombresTraducidos =
                  snapshotTraducido.data ?? nombresOriginales;

              final categorias = [
                lang.t('destacados'),
                ...nombresTraducidos,
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
