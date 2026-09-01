import 'package:flutter/material.dart';
import '../carrito_data.dart';
import '../favoritos_data.dart';

class DetalleProductoPage extends StatefulWidget {
  final Map<String, dynamic> producto;

  const DetalleProductoPage({super.key, required this.producto});

  @override
  State<DetalleProductoPage> createState() => _DetalleProductoPageState();
}

class _DetalleProductoPageState extends State<DetalleProductoPage> {
  int cantidad = 1;

  // VERIFICAR SI ES FAVORITO
  bool esFavorito() {
    return FavoritosData.favoritos.any(
      (productoFavorito) =>
          productoFavorito['index'] == widget.producto['index'],
    );
  }

  // AGREGAR O QUITAR FAVORITO
  void agregarFavorito() {
    setState(() {
      if (esFavorito()) {
        FavoritosData.favoritos.removeWhere(
          (productoFavorito) =>
              productoFavorito['index'] == widget.producto['index'],
        );
      } else {
        FavoritosData.favoritos.add({
          'index': widget.producto['index'],
          'nombre': widget.producto['nombre'],
          'precio': widget.producto['precio'],
          'descripcion': widget.producto['descripcion'],
          'icono': widget.producto['icono'],
        });
      }
    });
  }

  // AGREGAR AL CARRITO
  void agregarCarrito() {
    setState(() {
      final indexExistente = CarritoData.carrito.indexWhere(
        (productoCarrito) =>
            productoCarrito['index'] == widget.producto['index'],
      );

      if (indexExistente != -1) {
        CarritoData.carrito[indexExistente]['cantidad'] += cantidad;
      } else {
        CarritoData.carrito.add({
          'index': widget.producto['index'],
          'nombre': widget.producto['nombre'],
          'precio': widget.producto['precio'],
          'descripcion': widget.producto['descripcion'],
          'icono': widget.producto['icono'],
          'cantidad': cantidad,
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${widget.producto['nombre']} agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final producto = widget.producto;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      // BARRA SUPERIOR
      appBar: AppBar(
        title: const Text(
          'Detalle del producto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,

        actions: [
          IconButton(
            onPressed: agregarFavorito,
            icon: Icon(
              esFavorito() ? Icons.favorite : Icons.favorite_border,
              color: Colors.white,
            ),
          ),
        ],
      ),

      // CONTENIDO
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // IMAGEN / ICONO
            Container(
              width: double.infinity,
              height: 280,

              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(25),
              ),

              child: Icon(
                producto['icono'] as IconData,
                size: 130,
                color: Colors.green.shade700,
              ),
            ),

            const SizedBox(height: 25),

            // NOMBRE
            Text(
              producto['nombre'] as String,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            // PRECIO
            Text(
              producto['precio'] as String,
              style: TextStyle(
                color: Colors.green.shade700,
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 25),

            // DESCRIPCIÓN
            const Text(
              'Descripción',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // DESCRIPCIÓN DEL PRODUCTO
            Text(
              producto['descripcion'] as String,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 25),

            // CANTIDAD
            const Text(
              'Cantidad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                // RESTAR
                IconButton(
                  onPressed: () {
                    if (cantidad > 1) {
                      setState(() {
                        cantidad--;
                      });
                    }
                  },
                  icon: const Icon(Icons.remove_circle_outline, size: 32),
                ),

                // CANTIDAD
                Text(
                  '$cantidad',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                // SUMAR
                IconButton(
                  onPressed: () {
                    setState(() {
                      cantidad++;
                    });
                  },
                  icon: Icon(
                    Icons.add_circle_outline,
                    size: 32,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // BOTÓN AGREGAR AL CARRITO
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: agregarCarrito,

                icon: const Icon(Icons.shopping_cart),

                label: const Text(
                  'AGREGAR AL CARRITO',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  foregroundColor: Colors.white,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 15),

            // INFORMACIÓN
            Center(
              child: Text(
                'Producto seleccionado: ${producto['nombre']}',
                style: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
