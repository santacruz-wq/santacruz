
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
    // POSTRES
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

    // BEBIDAS
    'Michelada': 'bebida_michelada',
    'Michelada de sandía': 'bebida_michelada_sandia',
    'Michelada de Gatorade': 'bebida_michelada_gatorade',
    'Aromática de frutos rojos': 'bebida_aromatica_rojos',
    'Aromática de frutos amarillos': 'bebida_aromatica_amarillos',
    'Café especial': 'bebida_cafe_especial',
  };

  /// Traduce los productos conocidos con los textos estáticos.
  /// Los productos nuevos continúan utilizando Groq.
  static Future<List<String>> _obtenerTextosTraducidos(
    List<ProductModel> productos,
    String idioma,
  ) async {
    final nombres = productos.map((p) => p.nombre).toList();
    final descripciones =
        productos.map((p) => p.descripcion ?? '').toList();

    final textosPendientes = <String>[];
    final indicesPendientes = <int>[];

    for (var i = 0; i < productos.length; i++) {
      final producto = productos[i];

      // Primero identifica el producto por su código.
      final codigo = producto.productId.toString();
      final clavePorCodigo =
          TranslationPostres.obtenerClavePorCodigo(codigo);

      // Si no encuentra el código, intenta identificarlo por el nombre.
      final clave = clavePorCodigo ??
          _clavesPostres[producto.nombre.trim()];

      if (clave != null) {
        nombres[i] = TranslationPostres.obtenerNombre(
          clave: clave,
          idioma: idioma,
          nombreOriginal: producto.nombre,
        );

        descripciones[i] = TranslationPostres.obtenerDescripcion(
          clave: clave,
          idioma: idioma,
          descripcionOriginal: producto.descripcion ?? '',
        );
      } else if (idioma != 'es') {
        // Solo los productos nuevos se envían a Groq.
        indicesPendientes.add(i);
        textosPendientes.add(producto.nombre);
        textosPendientes.add(producto.descripcion ?? '');
      }
    }

    if (textosPendientes.isNotEmpty) {
      try {
        final traducidos = await TranslationService.traducirLista(
          textosPendientes,
          idioma,
        );

        for (var i = 0; i < indicesPendientes.length; i++) {
          final indice = indicesPendientes[i];
          final indiceNombre = i * 2;
          final indiceDescripcion = indiceNombre + 1;

          if (traducidos.length > indiceDescripcion) {
            nombres[indice] = traducidos[indiceNombre];
            descripciones[indice] = traducidos[indiceDescripcion];
          }
        }
      } catch (_) {
        // Si Groq falla, se conservan los textos originales.
      }
    }

    return [...nombres, ...descripciones];
  }

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
      future: _obtenerTextosTraducidos(
        products,
        lang.idiomaCodigo,
      ),
      builder: (context, snapshot) {
        final traducidos = snapshot.data != null &&
                snapshot.data!.length == products.length * 2
            ? snapshot.data!
            : textosOriginales;

        final nombresTraducidos =
            traducidos.take(products.length).toList();

        final descripcionesTraducidas =
            traducidos.skip(products.length).toList();

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
