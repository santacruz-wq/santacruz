class CarritoData {
  static final List<Map<String, dynamic>> carrito = [];

  static void agregarProducto(Map<String, dynamic> producto) {
    final index = carrito.indexWhere(
      (item) => item['index'] == producto['index'],
    );

    if (index != -1) {
      carrito[index]['cantidad'] = (carrito[index]['cantidad'] ?? 1) + 1;
    } else {
      carrito.add({...producto, 'cantidad': 1});
    }
  }

  static void aumentarCantidad(int index) {
    carrito[index]['cantidad']++;
  }

  static void disminuirCantidad(int index) {
    if (carrito[index]['cantidad'] > 1) {
      carrito[index]['cantidad']--;
    } else {
      carrito.removeAt(index);
    }
  }

  // CANCELAR / ELIMINAR UN PRODUCTO DEL CARRITO
  static void cancelarProducto(int index) {
    carrito.removeAt(index);
  }

  // CANCELAR TODO EL PEDIDO
  static void cancelarPedido() {
    carrito.clear();
  }
}
