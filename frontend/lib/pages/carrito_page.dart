import 'package:flutter/material.dart';
import '../carrito_data.dart';
import 'confirmar_pedido_page.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  // Convierte "$25.000" en 25000
  double convertirPrecio(String precio) {
    return double.parse(precio.replaceAll('\$', '').replaceAll('.', ''));
  }

  // Calcula el total
  double calcularTotal() {
    double total = 0;

    for (final producto in CarritoData.carrito) {
      final precio = convertirPrecio(producto['precio'] as String);

      final cantidad = producto['cantidad'] as int;

      total += precio * cantidad;
    }

    return total;
  }

  // Formatea el precio
  String formatoPrecio(double precio) {
    final numero = precio.toInt().toString();

    final partes = <String>[];
    var texto = numero;

    while (texto.length > 3) {
      partes.insert(0, texto.substring(texto.length - 3));

      texto = texto.substring(0, texto.length - 3);
    }

    partes.insert(0, texto);

    return '\$${partes.join('.')}';
  }

  // ==========================================
  // CONFIRMAR CANCELACIÓN DEL PEDIDO
  // ==========================================
  void confirmarCancelarPedido() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Cancelar pedido',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: const Text(
            '¿Estás seguro de que quieres cancelar todo el pedido? '
            'Se eliminarán todos los productos del carrito.',
          ),

          actions: [
            // NO CANCELAR
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'NO',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // SÍ CANCELAR
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CarritoData.cancelarPedido();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pedido cancelado correctamente'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),

              child: const Text('SÍ, CANCELAR'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoData.carrito;
    final total = calcularTotal();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Carrito',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      body: carrito.isEmpty
          // ==========================================
          // CARRITO VACÍO
          // ==========================================
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 15),

                  Text(
                    'Tu carrito está vacío',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          // ==========================================
          // CARRITO CON PRODUCTOS
          // ==========================================
          : Column(
              children: [
                // LISTA
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),

                    itemCount: carrito.length,

                    itemBuilder: (context, index) {
                      final producto = carrito[index];

                      final precio = convertirPrecio(
                        producto['precio'] as String,
                      );

                      final cantidad = producto['cantidad'] as int;

                      final subtotal = precio * cantidad;

                      return Container(
                        margin: const EdgeInsets.only(bottom: 15),

                        padding: const EdgeInsets.all(12),

                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18),

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),

                              blurRadius: 8,

                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),

                        child: Row(
                          children: [
                            // ==================================
                            // ICONO
                            // ==================================
                            Container(
                              width: 80,
                              height: 80,

                              decoration: BoxDecoration(
                                color: Colors.green.shade50,

                                borderRadius: BorderRadius.circular(15),
                              ),

                              child: Icon(
                                producto['icono'] as IconData,

                                size: 40,

                                color: Colors.green.shade700,
                              ),
                            ),

                            const SizedBox(width: 15),

                            // ==================================
                            // INFORMACIÓN
                            // ==================================
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  // NOMBRE
                                  Text(
                                    producto['nombre'] as String,

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),

                                  const SizedBox(height: 5),

                                  // PRECIO
                                  Text(
                                    producto['precio'] as String,

                                    style: TextStyle(
                                      color: Colors.green.shade700,

                                      fontWeight: FontWeight.bold,

                                      fontSize: 16,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // CANTIDAD
                                  Row(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            CarritoData.disminuirCantidad(
                                              index,
                                            );
                                          });
                                        },

                                        icon: const Icon(
                                          Icons.remove_circle_outline,

                                          color: Colors.red,
                                        ),
                                      ),

                                      Text(
                                        '$cantidad',

                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),

                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            CarritoData.aumentarCantidad(index);
                                          });
                                        },

                                        icon: Icon(
                                          Icons.add_circle_outline,

                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 4),

                                  // SUBTOTAL
                                  Text(
                                    'Subtotal: '
                                    '${formatoPrecio(subtotal)}',

                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // ==================================
                            // ELIMINAR PRODUCTO
                            // ==================================
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  CarritoData.cancelarProducto(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Producto eliminado del carrito',
                                    ),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },

                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.red,
                                size: 30,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // ==========================================
                // PARTE INFERIOR
                // ==========================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),

                  decoration: BoxDecoration(
                    color: Colors.white,

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),

                        blurRadius: 8,

                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),

                  child: Column(
                    children: [
                      // TOTAL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,

                        children: [
                          const Text(
                            'TOTAL:',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Text(
                            formatoPrecio(total),

                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,

                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      // ======================================
                      // COMPRAR AHORA
                      // ======================================
                      SizedBox(
                        width: double.infinity,
                        height: 55,

                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ConfirmarPedidoPage(),
                              ),
                            );
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,

                            foregroundColor: Colors.white,

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text(
                            'COMPRAR AHORA',

                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 10),

                      // ======================================
                      // CANCELAR PEDIDO
                      // ======================================
                      SizedBox(
                        width: double.infinity,
                        height: 50,

                        child: OutlinedButton(
                          onPressed: confirmarCancelarPedido,

                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,

                            side: const BorderSide(
                              color: Colors.red,
                              width: 1.5,
                            ),

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),

                          child: const Text(
                            'CANCELAR PEDIDO',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
