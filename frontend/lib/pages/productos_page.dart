import 'package:flutter/material.dart';
import '../favoritos_data.dart';
import '../carrito_data.dart';
import 'detalle_producto_page.dart';

class ProductosPage extends StatefulWidget {
  const ProductosPage({super.key});

  @override
  State<ProductosPage> createState() => _ProductosPageState();
}

class _ProductosPageState extends State<ProductosPage> {
  @override
  Widget build(BuildContext context) {
    final productos = [
      {
        'nombre': 'Postre de capuchino',
        'precio': '\$15.000',
        'descripcion':
            'Delicioso postre de capuchino elaborado con una suave crema y un intenso sabor a café. Perfecto para disfrutar en cualquier momento.',
        'icono': Icons.coffee,
      },
      {
        'nombre': 'Postre de mora',
        'precio': '\$11.000',
        'descripcion':
            'Delicioso postre de mora preparado con una cremosa mezcla y el delicioso sabor de la mora. Una combinación dulce y refrescante.',
        'icono': Icons.cake,
      },
      {
        'nombre': 'Torta de tres leches',
        'precio': '\$25.000',
        'descripcion':
            'Suave y deliciosa torta de tres leches, preparada para ofrecer una textura húmeda y cremosa con un sabor irresistible.',
        'icono': Icons.cake,
      },
      {
        'nombre': 'Torta de café',
        'precio': '\$30.000',
        'descripcion':
            'Deliciosa torta de café con un suave sabor y aroma a café. Perfecta para acompañar una bebida caliente.',
        'icono': Icons.coffee,
      },
      
{
  'nombre': 'Cheesecake de fresa',
  'precio': '\$40.000',
  'descripcion':
      'Delicioso cheesecake de fresa con una textura cremosa y una dulce cobertura de fresa.',
  'icono': Icons.cake,
},
{
  'nombre': 'Brownie de chocolate',
  'precio': '\$22.000',
  'descripcion':
      'Suave y delicioso brownie de chocolate, preparado con un intenso sabor a chocolate y una textura irresistible.',
  'icono': Icons.cookie,
},
{
  'nombre': 'Cupcake de vainilla',
  'precio': '\$15.000',
  'descripcion':
      'Esponjoso cupcake de vainilla con una suave crema y un delicioso toque dulce.',
  'icono': Icons.cake,
},
{
  'nombre': 'Tarta de limón',
  'precio': '\$28.000',
  'descripcion':
      'Deliciosa tarta de limón con una combinación equilibrada entre el sabor dulce y el toque refrescante del limón.',
  'icono': Icons.pie_chart,
},


        

      
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Productos',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: GridView.builder(
          itemCount: productos.length,

          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 0.62,
          ),

          itemBuilder: (context, index) {
            final producto = productos[index];

            final esFavorito = FavoritosData.favoritos.any(
              (productoFavorito) => productoFavorito['index'] == index,
            );

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetalleProductoPage(
                      producto: {...producto, 'index': index},
                    ),
                  ),
                );
              },

              child: Container(
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
                    // ==========================================
                    // IMAGEN DEL PRODUCTO
                    // ==========================================
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
                            producto['icono'] as IconData,
                            size: 70,
                            color: Colors.green.shade700,
                          ),
                        ),

                        // ======================================
                        // BOTÓN FAVORITO
                        // ======================================
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
                                setState(() {
                                  if (esFavorito) {
                                    FavoritosData.favoritos.removeWhere(
                                      (productoFavorito) =>
                                          productoFavorito['index'] == index,
                                    );
                                  } else {
                                    FavoritosData.favoritos.add({
                                      'index': index,
                                      'nombre': producto['nombre'],
                                      'precio': producto['precio'],
                                      'descripcion': producto['descripcion'],
                                      'icono': producto['icono'],
                                    });
                                  }
                                });
                              },

                              icon: Icon(
                                esFavorito
                                    ? Icons.favorite
                                    : Icons.favorite_border,

                                color: esFavorito
                                    ? Colors.red
                                    : Colors.grey.shade700,

                                size: 25,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ==========================================
                    // INFORMACIÓN
                    // ==========================================
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            // NOMBRE
                            Text(
                              producto['nombre'] as String,

                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),

                            const SizedBox(height: 5),

                            // PRECIO
                            Text(
                              producto['precio'] as String,

                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),

                            const SizedBox(height: 6),

                            // DESCRIPCIÓN
                            Text(
                              producto['descripcion'] as String,

                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,

                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                                height: 1.3,
                              ),
                            ),

                            const Spacer(),

                            // ==================================
                            // BOTONES
                            // ==================================
                            Row(
                              children: [
                                // VER DETALLE
                                Expanded(
                                  child: SizedBox(
                                    height: 38,

                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DetalleProductoPage(
                                                  producto: {
                                                    ...producto,
                                                    'index': index,
                                                  },
                                                ),
                                          ),
                                        );
                                      },

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade700,
                                        foregroundColor: Colors.white,

                                        padding: EdgeInsets.zero,

                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                      ),

                                      child: const Text(
                                        'Ver detalle',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 6),

                                // CARRITO
                                Container(
                                  height: 38,
                                  width: 38,

                                  decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(10),
                                  ),

                                  child: IconButton(
                                    padding: EdgeInsets.zero,

                                    onPressed: () {
                                      setState(() {
                                        CarritoData.agregarProducto({
                                          'index': index,
                                          'nombre': producto['nombre'],
                                          'precio': producto['precio'],
                                          'descripcion':
                                              producto['descripcion'],
                                          'icono': producto['icono'],
                                        });
                                      });

                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${producto['nombre']} agregado al carrito',
                                          ),
                                          duration: const Duration(seconds: 1),
                                        ),
                                      );
                                    },

                                    icon: Icon(
                                      Icons.add_shopping_cart,
                                      color: Colors.green.shade700,
                                      size: 21,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
