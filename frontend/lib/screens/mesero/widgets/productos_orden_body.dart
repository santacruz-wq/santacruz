import 'package:flutter/material.dart';

import '../../../models/mesa_model.dart';
import '../../../models/producto_model.dart';
import 'productos_error.dart';
import 'productos_orden_lista.dart';

/// Maneja los estados de carga, error, vacío y lista de productos.
class ProductosOrdenBody extends StatelessWidget {
  final Future<List<ProductoModel>> productosFuture;
  final MesaModel mesa;
  final Map<String, int> cantidades;
  final Map<String, String> notas;
  final void Function(ProductoModel producto) onAgregar;
  final void Function(ProductoModel producto) onQuitar;
  final void Function(ProductoModel producto) onEditarNota;
  final VoidCallback onReintentar;

  const ProductosOrdenBody({
    super.key,
    required this.productosFuture,
    required this.mesa,
    required this.cantidades,
    required this.notas,
    required this.onAgregar,
    required this.onQuitar,
    required this.onEditarNota,
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
        // CARGANDO
        if (snapshot.connectionState ==
            ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        // ERROR
        if (snapshot.hasError) {
          return ProductosError(
            onReintentar: onReintentar,
          );
        }

        final productos = snapshot.data ?? [];

        // SIN PRODUCTOS
        if (productos.isEmpty) {
          return const Center(
            child: Text(
              'No hay productos disponibles',
            ),
          );
        }

        return ProductosOrdenLista(
          mesa: mesa,
          productos: productos,
          cantidades: cantidades,
          notas: notas,
          onAgregar: onAgregar,
          onQuitar: onQuitar,
          onEditarNota: onEditarNota,
        );
      },
    );
  }
}