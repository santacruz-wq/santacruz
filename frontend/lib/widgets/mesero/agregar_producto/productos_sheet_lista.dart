import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';
import 'producto_sheet_item.dart';

/// Maneja los estados de carga, error, vacío y lista del sheet.
class ProductosSheetLista extends StatelessWidget {
  final Future<List<ProductoModel>> productosFuture;
  final Map<String, int> cantidades;
  final Map<String, TextEditingController> notas;
  final void Function(ProductoModel producto) onAumentar;
  final void Function(ProductoModel producto) onDisminuir;
  final VoidCallback onReintentar;

  const ProductosSheetLista({
    super.key,
    required this.productosFuture,
    required this.cantidades,
    required this.notas,
    required this.onAumentar,
    required this.onDisminuir,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ProductoModel>>(
      future: productosFuture,
      builder: (
        context,
        snapshot,
      ) {
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'No se pudieron cargar los productos',
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: onReintentar,
                  child: const Text(
                    'Reintentar',
                  ),
                ),
              ],
            ),
          );
        }

        final productos = snapshot.data ?? [];

        if (productos.isEmpty) {
          return const Center(
            child: Text(
              'No hay productos disponibles',
            ),
          );
        }

        return ListView.builder(
          itemCount: productos.length,
          itemBuilder: (
            context,
            index,
          ) {
            final producto = productos[index];

            return ProductoSheetItem(
              producto: producto,
              cantidad: cantidades[producto.id] ?? 0,
              notaController: notas[producto.id],
              onAumentar: () => onAumentar(producto),
              onDisminuir: () => onDisminuir(producto),
            );
          },
        );
      },
    );
  }
}