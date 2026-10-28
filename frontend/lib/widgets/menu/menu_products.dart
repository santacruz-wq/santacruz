
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/app_colors.dart';
import '../../core/config/translation_postres.dart';
import '../../models/product_model.dart';
import '../../providers/language_provider.dart';
import '../../services/translation_service.dart';
import 'product_card.dart';
import '../global/product_detail_sheet.dart';

class MenuProducts extends StatelessWidget {
  final List<ProductModel> products;

  const MenuProducts({super.key, required this.products});

  static const Map<String, String> _clavesPostres = {
    'Salpicón con helado': 'postre_salpicon_helado',
    'Merengón tropical': 'postre_merengon_tropical',
    'Esponjado de frutos rojos': 'postre_esponjado_frutos_rojos',
    'Esponjado de cholupa': 'postre_esponjado_cholupa',
    'Esponjado de maracumango': 'postre_esponjado_maracumango',
    'Esponjado de arequipe con coco': 'postre_esponjado_arequipe_coco',
    'Postre de tres leches': 'postre_tres_leches',
    'Postre de Milo': 'postre_milo',
    'Flan de leche asada': 'postre_flan_leche_asada',
    'Flan de café': 'postre_flan_cafe',
    'Torta de chocolate': 'postre_torta_chocolate',
    'Torta Red Velvet': 'postre_torta_red_velvet',
    'Postre de limón': 'postre_limon',
  };

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
    final textosOriginales = [
      ...nombresOriginales,
      ...descripcionesOriginales,
    ];

    return FutureBuilder<List<String>>(
      key: ValueKey(lang.idiomaCodigo),
      future: lang.idiomaCodigo == 'es'
          ? Future.value(textosOriginales)
          : TranslationService.traducirLista(
              textosOriginales,
              lang.idiomaCodigo,
            ),
      builder: (context, snapshot) {
        final traducidos =
            snapshot.data != null &&
                    snapshot.data!.length == textosOriginales.length
                ? snapshot.data!
                : textosOriginales;

        final nombresTraducidos = traducidos
            .take(products.length)
            .toList();

        final descripcionesTraducidas = traducidos
            .skip(products.length)
            .toList();

        for (var i = 0; i < products.length; i++) {
          final clave = _clavesPostres[products[i].nombre.trim()];

          if (clave != null) {
            nombresTraducidos[i] = TranslationPostres.obtenerNombre(
              clave: clave,
              idioma: lang.idiomaCodigo,
              nombreOriginal: products[i].nombre,
            );
          }
        }

        return SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 18),
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
                child: ProductCard(
                  id: product.id,
                  name: nombresTraducidos[index],
                  price: '\$${product.precio.toStringAsFixed(0)}',
                  image: product.imagenUrl,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
