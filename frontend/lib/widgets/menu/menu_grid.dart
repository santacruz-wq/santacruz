import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/config/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/language_provider.dart';
import '../../services/translation_service.dart';
import 'product_grid_card.dart';
import '../global/product_detail_sheet.dart';

class MenuGrid extends StatelessWidget {
  final List<ProductModel> products;

  const MenuGrid({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final lang = context.watch<LanguageProvider>();

    if (products.isEmpty) {
      return SizedBox(
        height: 100,
        child: Center(
          child: Text(
            lang.t('no_hay_productos'),
            style: const TextStyle(
              color: AppColors.textoCafe,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    final nombresOriginales = products.map((p) => p.nombre).toList();
    final descripcionesOriginales =
        products.map((p) => p.descripcion ?? '').toList();
    final textosOriginales = [...nombresOriginales, ...descripcionesOriginales];

    return FutureBuilder<List<String>>(
      key: ValueKey(lang.idiomaCodigo),
      future: TranslationService.traducirLista(
        textosOriginales,
        lang.idiomaCodigo,
      ),
      builder: (context, snapshot) {
        final traducidos = snapshot.data ?? textosOriginales;
        final nombresTraducidos = traducidos.sublist(0, products.length);
        final descripcionesTraducidas = traducidos.sublist(products.length);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () => mostrarDetalleProducto(
                context,
                name: nombresTraducidos[index],
                price: '\$${product.precio.toStringAsFixed(0)}',
                image: product.imagenUrl,
                description: descripcionesTraducidas[index],
                disponible: product.disponible,
              ),
              child: ProductGridCard(
                name: nombresTraducidos[index],
                price: '\$${product.precio.toStringAsFixed(0)}',
                image: product.imagenUrl,
              ),
            );
          },
        );
      },
    );
  }
}