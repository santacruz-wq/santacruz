import 'package:flutter/material.dart';
import '../favoritos_data.dart';
import '../carrito_data.dart';

class OfertasPage extends StatefulWidget {
  const OfertasPage({super.key});

  @override
  State<OfertasPage> createState() => _OfertasPageState();
}

class _OfertasPageState extends State<OfertasPage> {
  final List<Map<String, dynamic>> ofertas = [
    {
      'index': 0,
      'nombre': 'Postre de capuchino',
      'precioAnterior': '\$25.000',
      'precio': '\$20.000',
      'descripcion':
          'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
    },
    {
      'index': 1,
      'nombre': 'Postre de mora',
      'precioAnterior': '\$35.000',
      'precio': '\$28.000',
      'descripcion':
          'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 2,
      'nombre': 'Torta de tres leches',
      'precioAnterior': '\$45.000',
      'precio': '\$36.000',
      'descripcion':
          'Suave y deliciosa torta de tres leches con una textura húmeda y cremosa.',
      'icono': Icons.cake,
      'descuento': '20% OFF',
    },
    {
      'index': 3,
      'nombre': 'Torta de café',
      'precioAnterior': '\$55.000',
      'precio': '\$44.000',
      'descripcion':
          'Deliciosa torta de café con un suave sabor y aroma a café.',
      'icono': Icons.coffee,
      'descuento': '20% OFF',
    },
  ];

  bool esFavorito(int index) {
    return FavoritosData.favoritos.any(
      (producto) => producto['index'] == index,
    );
  }

  void alternarFavorito(Map<String, dynamic> oferta) {
    final index = oferta['index'];

    setState(() {
      final existe = FavoritosData.favoritos.any(
        (producto) => producto['index'] == index,
      );

      if (existe) {
        FavoritosData.favoritos.removeWhere(
          (producto) => producto['index'] == index,
        );
      } else {
        FavoritosData.favoritos.add({
          'index': oferta['index'],
          'nombre': oferta['nombre'],
          'precio': oferta['precio'],
          'descripcion': oferta['descripcion'],
          'icono': oferta['icono'],
        });
      }
    });
  }

  void agregarAlCarrito(Map<String, dynamic> oferta) {
    CarritoData.agregarProducto({
      'index': oferta['index'],
      'nombre': oferta['nombre'],
      'precio': oferta['precio'],
      'descripcion': oferta['descripcion'],
      'icono': oferta['icono'],
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${oferta['nombre']} agregado al carrito'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'Ofertas',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ofertas.length,

        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.62,
        ),

        itemBuilder: (context, index) {
          final oferta = ofertas[index];

          final favorito = esFavorito(oferta['index']);

          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),

              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ======================================
                // IMAGEN / ICONO
                // ======================================
                Stack(
                  children: [
                    Container(
                      height: 145,
                      width: double.infinity,

                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),

                      child: Icon(
                        oferta['icono'] as IconData,
                        size: 70,
                        color: Colors.green.shade700,
                      ),
                    ),

                    // DESCUENTO
                    Positioned(
                      top: 8,
                      left: 8,

                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),

                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Text(
                          oferta['descuento'] as String,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    // FAVORITO
                    Positioned(
                      top: 8,
                      right: 8,

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,

                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.15),
                              blurRadius: 6,
                            ),
                          ],
                        ),

                        child: IconButton(
                          onPressed: () {
                            alternarFavorito(oferta);
                          },

                          icon: Icon(
                            favorito ? Icons.favorite : Icons.favorite_border,

                            color: favorito ? Colors.red : Colors.grey.shade700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // ======================================
                // INFORMACIÓN
                // ======================================
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),

                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // NOMBRE
                        Text(
                          oferta['nombre'] as String,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),

                        const SizedBox(height: 5),

                        // PRECIO ANTERIOR
                        Text(
                          oferta['precioAnterior'] as String,

                          style: const TextStyle(
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 2),

                        // PRECIO OFERTA
                        Text(
                          oferta['precio'] as String,

                          style: TextStyle(
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),

                        const SizedBox(height: 6),

                        // DESCRIPCIÓN
                        Text(
                          oferta['descripcion'] as String,

                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,

                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                            height: 1.3,
                          ),
                        ),

                        const Spacer(),

                        // ==================================
                        // AGREGAR AL CARRITO
                        // ==================================
                        SizedBox(
                          width: double.infinity,
                          height: 40,

                          child: ElevatedButton.icon(
                            onPressed: () {
                              agregarAlCarrito(oferta);
                            },

                            icon: const Icon(Icons.add_shopping_cart, size: 19),

                            label: const Text(
                              'Agregar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),

                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade700,

                              foregroundColor: Colors.white,

                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(11),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
