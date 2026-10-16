import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';

/// Arma la lista de productos elegidos (con su nota, si la hay)
/// lista para enviarse con onAgregar.
List<Map<String, dynamic>> construirSeleccion(
  List<ProductoModel> productos,
  Map<String, int> cantidades,
  Map<String, TextEditingController> notas,
) {
  final productosSeleccionados = <Map<String, dynamic>>[];

  for (final producto in productos) {
    final cantidad = cantidades[producto.id] ?? 0;

    if (cantidad > 0) {
      final nota = notas[producto.id]?.text.trim();

      final item = <String, dynamic>{
        "producto": producto.id,
        "cantidad": cantidad,
      };

      if (nota != null && nota.isNotEmpty) {
        item["notas"] = nota;
      }

      productosSeleccionados.add(item);
    }
  }

  return productosSeleccionados;
}