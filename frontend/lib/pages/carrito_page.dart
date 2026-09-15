import 'package:flutter/material.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';
import '../components/carrito/carrito_card.dart';
import 'confirmar_pedido_page.dart';

class CarritoPage extends StatefulWidget {
  const CarritoPage({super.key});

  @override
  State<CarritoPage> createState() => _CarritoPageState();
}

class _CarritoPageState extends State<CarritoPage> {
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6F4E37);
  static const Color cafeClaro = Color(0xFF8D6E63);
  static const Color crema = Color(0xFFF7F1E8);
  static const Color cremaClara = Color(0xFFFFFBF5);
  static const Color dorado = Color(0xFFD4A017);
  static const Color doradoClaro = Color(0xFFF3D27A);

  double convertirPrecio(String precio) {
    return double.parse(
      precio.replaceAll('\$', '').replaceAll('.', ''),
    );
  }

  double calcularTotal() {
    double total = 0;

    for (final producto in CarritoData.carrito) {
      final precio = convertirPrecio(producto['precio'] as String);
      final cantidad = producto['cantidad'] as int;
      total += precio * cantidad;
    }

    return total;
  }

  String formatoPrecio(double precio) {
    var texto = precio.toInt().toString();
    final partes = <String>[];

    while (texto.length > 3) {
      partes.insert(0, texto.substring(texto.length - 3));
      texto = texto.substring(0, texto.length - 3);
    }

    partes.insert(0, texto);

    return '\$${partes.join('.')}';
  }

  void confirmarCancelarPedido() {
    final oscuro = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor:
              oscuro ? const Color(0xFF2B211D) : cremaClara,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.10),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  IdiomaData.texto('cancelar_pedido'),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: oscuro ? Colors.white : cafeOscuro,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            IdiomaData.texto('confirmar_cancelar_pedido'),
            style: TextStyle(
              color: oscuro ? Colors.white70 : cafeClaro,
              height: 1.4,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                IdiomaData.texto('no'),
                style: const TextStyle(
                  color: cafe,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  CarritoData.cancelarPedido();
                });

                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: cafeOscuro,
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    content: Text(
                      IdiomaData.texto('pedido_cancelado'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
              child: Text(
                IdiomaData.texto('si_cancelar'),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,
      builder: (context, locale, child) {
        final carrito = CarritoData.carrito;
        final total = calcularTotal();
        final bool es = locale.languageCode == 'es';

        final oscuro =
            Theme.of(context).brightness == Brightness.dark;

        final fondo = Theme.of(context).scaffoldBackgroundColor;

        final fondoPanel =
            oscuro ? const Color(0xFF2B211D) : cremaClara;

        final textoPrincipal =
            oscuro ? Colors.white : cafeOscuro;

        return Scaffold(
          backgroundColor: fondo,

          // =========================================================
          // APP BAR
          // =========================================================
          appBar: AppBar(
            backgroundColor: cafeOscuro,
            foregroundColor: Colors.white,
            elevation: 0,
            centerTitle: true,
            title: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: dorado,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 21,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  IdiomaData.texto('mi_carrito'),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 23,
                  ),
                ),
              ],
            ),
          ),

          // =========================================================
          // CUERPO
          // =========================================================
          body: carrito.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(30),
                      decoration: BoxDecoration(
                        color: fondoPanel,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                          color: oscuro
                              ? cafeClaro.withValues(alpha: 0.25)
                              : doradoClaro,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: oscuro ? 0.18 : 0.07,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: doradoClaro.withValues(
                                alpha: oscuro ? 0.14 : 0.35,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.shopping_cart_outlined,
                              size: 65,
                              color: oscuro ? doradoClaro : cafe,
                            ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            IdiomaData.texto('carrito_vacio'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textoPrincipal,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            IdiomaData.texto(
                              'agrega_productos_carrito',
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color:
                                  oscuro ? Colors.white70 : cafeClaro,
                              fontSize: 14,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    // =================================================
                    // LISTA DE PRODUCTOS
                    // =================================================
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          16,
                          16,
                          16,
                          10,
                        ),
                        itemCount: carrito.length,
                        itemBuilder: (context, index) {
                          return CarritoCard(
                            producto: carrito[index],
                            index: index,
                            es: es,
                            onActualizar: () {
                              setState(() {});
                            },
                            onEliminar: () {
                              setState(() {
                                CarritoData.cancelarProducto(index);
                              });

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(
                                SnackBar(
                                  backgroundColor: cafeOscuro,
                                  behavior:
                                      SnackBarBehavior.floating,
                                  margin: const EdgeInsets.all(15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(14),
                                  ),
                                  content: Text(
                                    IdiomaData.texto(
                                      'producto_eliminado',
                                    ),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  duration:
                                      const Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),

                    // =================================================
                    // RESUMEN DEL PEDIDO
                    // =================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        20,
                        18,
                        20,
                        20,
                      ),
                      decoration: BoxDecoration(
                        color: fondoPanel,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(28),
                          topRight: Radius.circular(28),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(
                              alpha: oscuro ? 0.25 : 0.12,
                            ),
                            blurRadius: 14,
                            offset: const Offset(0, -4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding:
                                        const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          doradoClaro.withValues(
                                        alpha:
                                            oscuro ? 0.14 : 0.30,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10),
                                    ),
                                    child: Icon(
                                      Icons.receipt_long,
                                      color: oscuro
                                          ? doradoClaro
                                          : cafe,
                                      size: 22,
                                    ),
                                  ),
                                  const SizedBox(width: 9),
                                  Text(
                                    '${IdiomaData.texto('total')}:',
                                    style: TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                      color: textoPrincipal,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                formatoPrecio(total),
                                style: TextStyle(
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                  color: oscuro
                                      ? doradoClaro
                                      : dorado,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // =================================================
                          // COMPRAR AHORA
                          // =================================================
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ConfirmarPedidoPage(),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.shopping_bag,
                                size: 21,
                              ),
                              label: Text(
                                IdiomaData.texto('comprar_ahora'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: cafe,
                                foregroundColor: Colors.white,
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =================================================
                          // CANCELAR PEDIDO
                          // =================================================
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton.icon(
                              onPressed:
                                  confirmarCancelarPedido,
                              icon: const Icon(
                                Icons.delete_outline,
                                size: 20,
                              ),
                              label: Text(
                                IdiomaData.texto(
                                  'cancelar_pedido',
                                ),
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 1.5,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(15),
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
      },
    );
  }
}
