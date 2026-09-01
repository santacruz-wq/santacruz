import 'package:flutter/material.dart';
import '../carrito_data.dart';

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

  double convertirPrecio(String precio) {
    return double.parse(precio.replaceAll('\$', '').replaceAll('.', ''));
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

  @override
  void dispose() {
    nombreController.dispose();
    telefonoController.dispose();
    direccionController.dispose();
    observacionesController.dispose();

    super.dispose();
  }

  // ==========================================
  // CONFIRMAR PEDIDO
  // ==========================================
  void confirmarPedido() {
    if (nombreController.text.trim().isEmpty ||
        telefonoController.text.trim().isEmpty ||
        direccionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa nombre, teléfono y dirección.'),
        ),
      );

      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Confirmar pedido',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),

          content: const Text('¿Deseas confirmar este pedido?'),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },

              child: const Text(
                'CANCELAR',
                style: TextStyle(color: Colors.grey),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                mostrarPedidoConfirmado();
              },

              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),

              child: const Text('CONFIRMAR'),
            ),
          ],
        );
      },
    );
  }

  // ==========================================
  // PEDIDO CONFIRMADO
  // ==========================================
  void mostrarPedidoConfirmado() {
    final total = calcularTotal();

    showDialog(
      context: context,
      barrierDismissible: false,

      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 90,
                height: 90,

                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  shape: BoxShape.circle,
                ),

                child: Icon(
                  Icons.check_circle,
                  size: 70,
                  color: Colors.green.shade700,
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                '¡Pedido confirmado!',
                textAlign: TextAlign.center,

                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 10),

              const Text(
                'Tu pedido ha sido recibido correctamente.',
                textAlign: TextAlign.center,

                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),

              const SizedBox(height: 15),

              Text(
                'Total: ${formatoPrecio(total)}',

                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade700,
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
                    backgroundColor: Colors.green.shade700,
                    foregroundColor: Colors.white,

                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),

                  child: const Text('VOLVER AL INICIO'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ==========================================
  // CAMPO DE TEXTO
  // ==========================================
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

        prefixIcon: Icon(icono, color: Colors.green.shade700),

        filled: true,
        fillColor: Colors.white,

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide(color: Colors.grey.shade200),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),

          borderSide: BorderSide(color: Colors.green.shade700, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final carrito = CarritoData.carrito;
    final total = calcularTotal();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F5),

      appBar: AppBar(
        title: const Text(
          'Confirmar pedido',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        centerTitle: true,

        backgroundColor: Colors.green.shade700,

        foregroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // ======================================
            // TÍTULO
            // ======================================
            const Text(
              'Revisa tu pedido',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            const Text(
              'Completa tus datos antes de confirmar.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),

            const SizedBox(height: 20),

            // ======================================
            // DATOS DEL CLIENTE
            // ======================================
            Container(
              padding: const EdgeInsets.all(16),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),

                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),

                    blurRadius: 8,

                    offset: const Offset(0, 3),
                  ),
                ],
              ),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  const Text(
                    'Datos de entrega',
                    style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 15),

                  campoTexto(
                    etiqueta: 'Nombre completo',
                    hint: 'Ej: Juan Pérez',
                    icono: Icons.person,
                    controller: nombreController,
                  ),

                  const SizedBox(height: 12),

                  campoTexto(
                    etiqueta: 'Teléfono',
                    hint: 'Ej: 3001234567',
                    icono: Icons.phone,
                    controller: telefonoController,
                    tipoTeclado: TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  campoTexto(
                    etiqueta: 'Dirección',
                    hint: 'Ej: Calle 10 # 5-20',
                    icono: Icons.location_on,
                    controller: direccionController,
                  ),

                  const SizedBox(height: 12),

                  campoTexto(
                    etiqueta: 'Observaciones',
                    hint: 'Ej: Entregar después de las 5 PM',
                    icono: Icons.notes,
                    controller: observacionesController,
                    maxLineas: 3,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ======================================
            // PRODUCTOS
            // ======================================
            const Text(
              'Resumen del pedido',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            ...carrito.map((producto) {
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
                      color: Colors.black.withValues(alpha: 0.05),

                      blurRadius: 6,
                    ),
                  ],
                ),

                child: Row(
                  children: [
                    Container(
                      width: 55,
                      height: 55,

                      decoration: BoxDecoration(
                        color: Colors.green.shade50,

                        borderRadius: BorderRadius.circular(12),
                      ),

                      child: Icon(
                        producto['icono'] as IconData,

                        color: Colors.green.shade700,

                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,

                        children: [
                          Text(
                            producto['nombre'] as String,

                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            'Cantidad: $cantidad',

                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),

                    Text(
                      formatoPrecio(subtotal),

                      style: TextStyle(
                        fontWeight: FontWeight.bold,

                        color: Colors.green.shade700,

                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              );
            }),

            const SizedBox(height: 10),

            // ======================================
            // TOTAL
            // ======================================
            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.green.shade50,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(color: Colors.green.shade200),
              ),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'TOTAL DEL PEDIDO',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
            ),

            const SizedBox(height: 20),

            // ======================================
            // CONFIRMAR
            // ======================================
            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton.icon(
                onPressed: confirmarPedido,

                icon: const Icon(Icons.check_circle),

                label: const Text(
                  'CONFIRMAR PEDIDO',

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

            const SizedBox(height: 12),

            // ======================================
            // CANCELAR
            // ======================================
            SizedBox(
              width: double.infinity,
              height: 50,

              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },

                icon: const Icon(Icons.arrow_back),

                label: const Text(
                  'VOLVER AL CARRITO',

                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),

                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.grey.shade700,

                  side: BorderSide(color: Colors.grey.shade400),

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
  }
}
