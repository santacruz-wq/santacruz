import 'package:flutter/material.dart';

import '../../../models/producto_model.dart';

/// Arma la lista de productos seleccionados lista para enviar al backend.
List<Map<String, dynamic>> construirProductosOrden(
  List<ProductoModel> productos,
  Map<String, int> cantidades,
  Map<String, String> notas,
) {
  final productosOrden = <Map<String, dynamic>>[];

  for (final producto in productos) {
    final cantidad = cantidades[producto.id] ?? 0;

    if (cantidad > 0) {
      final nota = notas[producto.id];

      productosOrden.add({
        "producto": producto.id,
        "cantidad": cantidad,
        "notas": nota ?? '',
      });
    }
  }

  return productosOrden;
}

/// Muestra un mensaje flotante (SnackBar).
void mostrarMensaje(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      behavior: SnackBarBehavior.floating,
    ),
  );
}