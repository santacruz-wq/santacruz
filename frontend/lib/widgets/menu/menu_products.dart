import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product_model.dart';
import '../../providers/language_provider.dart';
import '../../services/translation_service.dart';
import 'product_card.dart';

class MenuProducts extends StatelessWidget {
  final List<Product> products;

  const MenuProducts({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const SizedBox(
        height: 100,
        child: Center(child: Text('No hay productos')),
      );
    }

    final lang = context.watch<LanguageProvider>();
    final nombresOriginales = products.map((p) => p.nombre).toList();

    return SizedBox(
      height: 300,
      child: FutureBuilder<List<String>>(
        key: ValueKey(lang.idiomaCodigo),
        future: TranslationService.traducirLista(
          nombresOriginales,
          lang.idiomaCodigo,
        ),
        builder: (context, snapshot) {
          final nombresTraducidos = snapshot.data ?? nombresOriginales;

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 18),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                id: product.id, // AGREGADO
                name: nombresTraducidos[index],
                price: '\$${product.precio.toStringAsFixed(0)}',
                image: product.imagenUrl,
              );
            },
          );
        },
      ),
    );
  }
}