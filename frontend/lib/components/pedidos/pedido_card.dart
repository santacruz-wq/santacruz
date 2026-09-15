import 'package:flutter/material.dart';

class PedidoCard extends StatelessWidget {
  final Map<String, dynamic> pedido;
  final VoidCallback onTap;

  const PedidoCard({super.key, required this.pedido, required this.onTap});

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

  IconData iconoEstado(String estado) {
    switch (estado) {
      case 'Entregado':
        return Icons.check_circle_outline;

      case 'En camino':
        return Icons.local_shipping_outlined;

      case 'Pendiente':
        return Icons.access_time;

      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String estado = pedido['estado'];

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Pedido ${pedido['numero']}',
                    style: const TextStyle(
                      color: cafeOscuro,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: colorEstado(estado).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        iconoEstado(estado),
                        color: colorEstado(estado),
                        size: 16,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        estado,
                        style: TextStyle(
                          color: colorEstado(estado),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 16,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(width: 7),
                Text(
                  pedido['fecha'],
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              pedido['productos'],
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: cafeOscuro, fontSize: 14),
            ),

            const SizedBox(height: 13),

            const Divider(height: 1, color: Color(0xFFE5D5C8)),

            const SizedBox(height: 12),

            Row(
              children: [
                const Text(
                  'Total',
                  style: TextStyle(color: cafeOscuro, fontSize: 14),
                ),

                const Spacer(),

                Text(
                  pedido['total'],
                  style: const TextStyle(
                    color: cafe,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(width: 8),

                const Icon(
                  Icons.arrow_forward_ios,
                  size: 15,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
