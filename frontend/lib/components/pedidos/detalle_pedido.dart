import 'package:flutter/material.dart';

class DetallePedido extends StatelessWidget {
  final Map<String, dynamic> pedido;

  const DetallePedido({
    super.key,
    required this.pedido,
  });

  static const Color cafeOscuro = Color(0xFF4E342E);
  static const Color cafe = Color(0xFF6D4C41);
  static const Color dorado = Color(0xFFC49A3A);

  Color colorEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return Colors.green.shade700;
      case 'En camino':
        return dorado;
      case 'Pendiente':
        return cafe;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String estado = pedido['estado'];

    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: const Text(
        'Detalle del pedido',
        style: TextStyle(
          color: cafeOscuro,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pedido ${pedido['numero']}',
              style: const TextStyle(
                color: cafe,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Fecha: ${pedido['fecha']}',
              style: const TextStyle(color: cafeOscuro),
            ),
            const SizedBox(height: 10),
            Text(
              'Productos: ${pedido['productos']}',
              style: const TextStyle(color: cafeOscuro),
            ),
            const SizedBox(height: 10),
            Text(
              'Total: ${pedido['total']}',
              style: const TextStyle(
                color: cafe,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Método de pago: ${pedido['metodoPago']}',
              style: const TextStyle(color: cafeOscuro),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Text(
                  'Estado: ',
                  style: TextStyle(
                    color: cafeOscuro,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  estado,
                  style: TextStyle(
                    color: colorEstado(estado),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text(
            'Cerrar',
            style: TextStyle(
              color: cafe,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}