import 'package:flutter/material.dart';

import '../../../models/mesa_model.dart';
import '../../../models/producto_model.dart';
import 'producto_orden_item.dart';

class ProductosOrdenLista extends StatelessWidget {
  final MesaModel mesa;
  final List<ProductoModel> productos;
  final Map<String, int> cantidades;
  final Map<String, String> notas;
  final void Function(ProductoModel producto) onAgregar;
  final void Function(ProductoModel producto) onQuitar;
  final void Function(ProductoModel producto) onEditarNota;

  const ProductosOrdenLista({
    super.key,
    required this.mesa,
    required this.productos,
    required this.cantidades,
    required this.notas,
    required this.onAgregar,
    required this.onQuitar,
    required this.onEditarNota,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // INFORMACIÓN DE LA MESA
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          child: Text(
            'Mesa: ${mesa.nombre}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        // LISTA DE PRODUCTOS
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            itemCount: productos.length,
            itemBuilder: (
              context,
              index,
            ) {
              final producto = productos[index];

              return ProductoOrdenItem(
                producto: producto,
                cantidad: cantidades[producto.id] ?? 0,
                nota: notas[producto.id],
                onAgregar: () => onAgregar(producto),
                onQuitar: () => onQuitar(producto),
                onEditarNota: () => onEditarNota(producto),
              );
            },
          ),
        ),
      ],
    );
  }
}