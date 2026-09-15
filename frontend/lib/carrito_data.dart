import 'package:flutter/foundation.dart';

class CarritoData {
  static final List<Map<String, dynamic>> carrito = [];

  // Notifica cuando cambia el carrito
  static final ValueNotifier<int> cantidadProductos = ValueNotifier<int>(0);

  static void actualizarCantidad() {
    int total = 0;

    for (final producto in carrito) {
      total += (producto['cantidad'] ?? 1) as int;
    }

    cantidadProductos.value = total;
  }

  static void agregarProducto(Map<String, dynamic> producto) {
    final index = carrito.indexWhere(
      (item) => item['index'] == producto['index'],
    );

    if (index != -1) {
      carrito[index]['cantidad'] = (carrito[index]['cantidad'] ?? 1) + 1;
    } else {
      carrito.add({...producto, 'cantidad': 1});
    }

    actualizarCantidad();
  }

  static void aumentarCantidad(int index) {
    carrito[index]['cantidad']++;
    actualizarCantidad();
  }

  static void disminuirCantidad(int index) {
    if (carrito[index]['cantidad'] > 1) {
      carrito[index]['cantidad']--;
    } else {
      carrito.removeAt(index);
    }

    actualizarCantidad();
  }

  // CANCELAR / ELIMINAR UN PRODUCTO DEL CARRITO
  static void cancelarProducto(int index) {
    carrito.removeAt(index);
    actualizarCantidad();
  }

  // CANCELAR TODO EL PEDIDO
  static void cancelarPedido() {
    carrito.clear();
    actualizarCantidad();
  }
}
