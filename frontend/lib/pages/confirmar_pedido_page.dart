import 'package:flutter/material.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';

class ConfirmarPedidoPage extends StatefulWidget {
  const ConfirmarPedidoPage({super.key});

  @override
  State<ConfirmarPedidoPage> createState() => _ConfirmarPedidoPageState();
}

class _ConfirmarPedidoPageState extends State<ConfirmarPedidoPage> {
  final nombreController = TextEditingController();
  final telefonoController = TextEditingController();
  final direccionController = TextEditingController();
  final observacionesController = TextEditingController();

  // ================================================================
  // MÉTODO DE PAGO
  // ================================================================

  String metodoPago = 'Efectivo';

  // ================================================================
  // COLORES
  // ================================================================

  static const Color cafe = Color(0xFF6D4C41);
  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color crema = Color(0xFFFFF8E7);
  static const Color dorado = Color(0xFFC49A3A);
  static const Color fondo = Color(0xFFF8F3EA);
  static const Color textoGris = Color(0xFF6D625D);

  // ================================================================
  // CONVERTIR PRECIO
  // ================================================================

  double convertirPrecio(String precio) {
    return double.parse(precio.replaceAll('\$', '').replaceAll('.', ''));
  }

  // ================================================================
  // CALCULAR TOTAL
  // ================================================================

  double calcularTotal() {
    double total = 0;

    for (final producto in CarritoData.carrito) {
      final precio = convertirPrecio(producto['precio'] as String);
      final cantidad = producto['cantidad'] as int;

      total += precio * cantidad;
    }

    return total;
  }

  // ================================================================
  // FORMATEAR PRECIO
  // ================================================================

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

  // ================================================================
  // NOMBRE DEL PRODUCTO SEGÚN EL IDIOMA
  // ================================================================

  String nombreProducto(Map<String, dynamic> producto, bool es) {
    switch (producto['index']) {
      case 0:
        return es ? 'Postre de capuchino' : 'Cappuccino dessert';

      case 1:
        return es ? 'Postre de mora' : 'Blackberry dessert';

      case 2:
        return es ? 'Torta de tres leches' : 'Tres leches cake';

      case 3:
        return es ? 'Torta de café' : 'Coffee cake';

      case 4:
        return es ? 'Cheesecake de fresa' : 'Strawberry cheesecake';

      case 5:
        return es ? 'Brownie de chocolate' : 'Chocolate brownie';

      case 6:
        return es ? 'Cupcake de vainilla' : 'Vanilla cupcake';

      case 7:
        return es ? 'Tarta de limón' : 'Lemon pie';

      default:
        return producto['nombre'] as String? ?? '';
    }
  }

  // ================================================================
  // DISPOSE
  // ================================================================

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    observacionesController.dispose();

    super.dispose();
  }

  // ================================================================
  // CONFIRMAR PEDIDO
  // ================================================================

  void confirmarPedido() {
    if (nombreController.text.trim().isEmpty ||
        telefonoController.text.trim().isEmpty ||
        direccionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(IdiomaData.texto('completar_datos')),
          backgroundColor: cafeOscuro,
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: crema,

          title: Text(
            IdiomaData.texto('confirmar_pedido'),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: cafeOscuro,
            ),
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                IdiomaData.texto('deseas_confirmar_pedido'),
                style: const TextStyle(color: textoGris),
              ),

              const SizedBox(height: 15),

              Text(
                '${IdiomaData.texto('total')}: '
                '${formatoPrecio(calcularTotal())}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: dorado,
                  fontSize: 17,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Método de pago: $metodoPago',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cafeOscuro,
                ),
              ),
            ],
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                IdiomaData.texto('cancelar'),
                style: const TextStyle(color: textoGris),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                mostrarPedidoConfirmado();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: cafe,
                foregroundColor: Colors.white,
              ),
              child: Text(IdiomaData.texto('confirmar')),
            ),
          ],
        );
      },
    );
  }

  // ================================================================
  // PEDIDO CONFIRMADO
  // ================================================================

  void mostrarPedidoConfirmado() {
    final total = calcularTotal();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: crema,

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: dorado.withOpacity(0.18),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle, size: 70, color: dorado),
              ),

              const SizedBox(height: 20),

              Text(
                IdiomaData.texto('pedido_confirmado'),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: cafeOscuro,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                IdiomaData.texto('pedido_recibido'),
                textAlign: TextAlign.center,
                style: const TextStyle(color: textoGris, fontSize: 15),
              ),

              const SizedBox(height: 15),

              Text(
                '${IdiomaData.texto('total')}: '
                '${formatoPrecio(total)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: dorado,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'Método de pago: $metodoPago',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: cafeOscuro,
                ),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    CarritoData.carrito.clear();

                    Navigator.pop(context);

                    Navigator.popUntil(context, (route) => route.isFirst);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: cafe,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(IdiomaData.texto('volver_inicio')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ================================================================
  // CAMPO DE TEXTO
  // ================================================================

  Widget campoTexto({
    required String etiqueta,
    required String hint,
    required IconData icono,
    required TextEditingController controller,
    TextInputType? tipoTeclado,
    int maxLineas = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: tipoTeclado,
      maxLines: maxLineas,

      decoration: InputDecoration(
        labelText: etiqueta,
        hintText: hint,

        prefixIcon: Icon(icono, color: cafe),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: dorado.withOpacity(0.25)),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: cafe, width: 2),
        ),
      ),
    );
  }

  // ================================================================
  // BUILD
  // ================================================================

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
      valueListenable: IdiomaData.idioma,

      builder: (context, locale, child) {
        final carrito = CarritoData.carrito;
        final total = calcularTotal();
        final bool es = locale.languageCode == 'es';

        return Scaffold(
          backgroundColor: fondo,

          // ========================================================
          // APP BAR
          // ========================================================
          appBar: AppBar(
            title: Text(
              IdiomaData.texto('confirmar_pedido'),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),

            centerTitle: true,

            backgroundColor: cafe,
            foregroundColor: Colors.white,
          ),

          // ========================================================
          // BODY
          // ========================================================
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(18),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                // ==================================================
                // TÍTULO
                // ==================================================
                Text(
                  IdiomaData.texto('revisa_tu_pedido'),
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cafeOscuro,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  IdiomaData.texto('completa_datos_confirmar'),
                  style: const TextStyle(color: textoGris, fontSize: 15),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // DATOS DEL CLIENTE
                // ==================================================
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        IdiomaData.texto('datos_entrega'),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: cafeOscuro,
                        ),
                      ),

                      const SizedBox(height: 15),

                      campoTexto(
                        etiqueta: IdiomaData.texto('nombre_completo'),
                        hint: IdiomaData.texto('ej_nombre'),
                        icono: Icons.person,
                        controller: nombreController,
                      ),

                      const SizedBox(height: 12),

                      campoTexto(
                        etiqueta: IdiomaData.texto('telefono'),
                        hint: IdiomaData.texto('ej_telefono'),
                        icono: Icons.phone,
                        controller: telefonoController,
                        tipoTeclado: TextInputType.phone,
                      ),

                      const SizedBox(height: 12),

                      campoTexto(
                        etiqueta: IdiomaData.texto('direccion'),
                        hint: IdiomaData.texto('ej_direccion'),
                        icono: Icons.location_on,
                        controller: direccionController,
                      ),

                      const SizedBox(height: 12),

                      campoTexto(
                        etiqueta: IdiomaData.texto('observaciones'),
                        hint: IdiomaData.texto('ej_observaciones'),
                        icono: Icons.notes,
                        controller: observacionesController,
                        maxLineas: 3,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // MÉTODO DE PAGO
                // ==================================================
                Container(
                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        es ? 'Método de pago' : 'Payment method',

                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          color: cafeOscuro,
                        ),
                      ),

                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: metodoPago,

                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.payment, color: cafe),

                          filled: true,
                          fillColor: crema,

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),
                        ),

                        items: [
                          DropdownMenuItem(
                            value: 'Efectivo',
                            child: Text(es ? 'Efectivo' : 'Cash'),
                          ),

                          DropdownMenuItem(
                            value: 'Tarjeta',
                            child: Text(es ? 'Tarjeta' : 'Card'),
                          ),

                          DropdownMenuItem(
                            value: 'Nequi',
                            child: const Text('Nequi'),
                          ),

                          DropdownMenuItem(
                            value: 'Daviplata',
                            child: const Text('Daviplata'),
                          ),
                        ],

                        onChanged: (valor) {
                          if (valor != null) {
                            setState(() {
                              metodoPago = valor;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // PRODUCTOS
                // ==================================================
                Text(
                  IdiomaData.texto('resumen_pedido'),
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                    color: cafeOscuro,
                  ),
                ),

                const SizedBox(height: 10),

                ...carrito.map((producto) {
                  final nombre = nombreProducto(producto, es);

                  final precio = convertirPrecio(producto['precio'] as String);

                  final cantidad = producto['cantidad'] as int;

                  final subtotal = precio * cantidad;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),

                    padding: const EdgeInsets.all(14),

                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),

                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),

                    child: Row(
                      children: [
                        // ICONO
                        Container(
                          width: 55,
                          height: 55,

                          decoration: BoxDecoration(
                            color: crema,
                            borderRadius: BorderRadius.circular(12),

                            border: Border.all(color: dorado.withOpacity(0.25)),
                          ),

                          child: Icon(
                            producto['icono'] as IconData,
                            color: cafe,
                            size: 30,
                          ),
                        ),

                        const SizedBox(width: 12),

                        // INFORMACIÓN
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                nombre,

                                maxLines: 2,

                                overflow: TextOverflow.ellipsis,

                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: cafeOscuro,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                '${IdiomaData.texto('cantidad')}: $cantidad',

                                style: const TextStyle(color: textoGris),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 8),

                        Text(
                          formatoPrecio(subtotal),

                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: dorado,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 10),

                // ==================================================
                // TOTAL
                // ==================================================
                Container(
                  width: double.infinity,

                  padding: const EdgeInsets.all(20),

                  decoration: BoxDecoration(
                    color: crema,
                    borderRadius: BorderRadius.circular(18),

                    border: Border.all(color: dorado.withOpacity(0.45)),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      Text(
                        IdiomaData.texto('total_pedido'),

                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: cafeOscuro,
                        ),
                      ),

                      Text(
                        formatoPrecio(total),

                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: dorado,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ==================================================
                // CONFIRMAR
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 55,

                  child: ElevatedButton.icon(
                    onPressed: confirmarPedido,

                    icon: const Icon(Icons.check_circle),

                    label: Text(
                      IdiomaData.texto('confirmar_pedido_boton'),

                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: ElevatedButton.styleFrom(
                      backgroundColor: cafe,
                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ==================================================
                // VOLVER AL CARRITO
                // ==================================================
                SizedBox(
                  width: double.infinity,
                  height: 50,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },

                    icon: const Icon(Icons.arrow_back),

                    label: Text(
                      IdiomaData.texto('volver_carrito'),

                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    style: OutlinedButton.styleFrom(
                      foregroundColor: cafe,

                      side: const BorderSide(color: cafe),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        );
      },
    );
  }
}
