import 'package:flutter/material.dart';
import '../carrito_data.dart';
import '../idioma_data.dart';
import '../notificaciones_data.dart';
import '../components/confirmar_pedido/confirmar_datos.dart';
import '../components/confirmar_pedido/confirmar_pago.dart';
import '../components/confirmar_pedido/confirmar_productos.dart';
import '../components/confirmar_pedido/confirmar_total.dart';
import '../components/confirmar_pedido/confirmar_botones.dart';
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
    // ==============================================================
  // CREAR NOTIFICACIÓN
  // ==============================================================

  final bool es =
      IdiomaData.idioma.value.languageCode == 'es';
NotificacionesData.agregarNotificacion(
    
  mensaje: es
      ? 'Tu pedido ha sido confirmado y está siendo preparado.'
      : 'Your order has been confirmed and is being prepared.',
  estado: 'confirmado',
  minutos: 25,
);
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
ConfirmarDatos(
  nombreController: nombreController,
  telefonoController: telefonoController,
  direccionController: direccionController,
  observacionesController: observacionesController,

  titulo: IdiomaData.texto('datos_entrega'),

  nombre: IdiomaData.texto('nombre_completo'),
  ejemploNombre: IdiomaData.texto('ej_nombre'),

  telefono: IdiomaData.texto('telefono'),
  ejemploTelefono: IdiomaData.texto('ej_telefono'),

  direccion: IdiomaData.texto('direccion'),
  ejemploDireccion: IdiomaData.texto('ej_direccion'),

  observaciones: IdiomaData.texto('observaciones'),
  ejemploObservaciones: IdiomaData.texto('ej_observaciones'),

  cafe: cafe,
  cafeOscuro: cafeOscuro,
  dorado: dorado,
  textoGris: textoGris,
  fondoCampo: Colors.white,
),

const SizedBox(height: 20),
                // ==================================================
                // MÉTODO DE PAGO
                // ==================================================
                  ConfirmarPago(
  metodoPago: metodoPago,
  es: es,

  titulo: es ? 'Método de pago' : 'Payment method',

  cafe: cafe,
  cafeOscuro: cafeOscuro,
  crema: crema,

  onChanged: (valor) {
    if (valor != null) {
      setState(() {
        metodoPago = valor;
      });
    }
  },
),

const SizedBox(height: 20),

                // ==================================================
                // PRODUCTOS
                // ==================================================
                    ConfirmarProductos(
  carrito: carrito,
  es: es,

  titulo: IdiomaData.texto('resumen_pedido'),
  textoCantidad: IdiomaData.texto('cantidad'),

  nombreProducto: nombreProducto,
  convertirPrecio: convertirPrecio,
  formatoPrecio: formatoPrecio,

  cafe: cafe,
  cafeOscuro: cafeOscuro,
  crema: crema,
  dorado: dorado,
  textoGris: textoGris,
),

const SizedBox(height: 10),

                // ==================================================
                // TOTAL
                // ==================================================
                    ConfirmarTotal(
  total: total,

  titulo: IdiomaData.texto('total_pedido'),

  formatoPrecio: formatoPrecio,

  cafeOscuro: cafeOscuro,
  crema: crema,
  dorado: dorado,
),
                const SizedBox(height: 20),

                // ==================================================
                //   BOTONES
                // ==================================================
                      ConfirmarBotones(
  onConfirmar: confirmarPedido,

  onVolver: () {
    Navigator.pop(context);
  },

  textoConfirmar:
      IdiomaData.texto('confirmar_pedido_boton'),

  textoVolver:
      IdiomaData.texto('volver_carrito'),

  cafe: cafe,
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
