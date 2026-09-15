import 'package:flutter/foundation.dart';

class PedidosData {
  // ============================================================
  // LISTA COMPARTIDA DE PEDIDOS
  // ============================================================

  static final List<Map<String, dynamic>> pedidos = [
    {
      'numero': '#001',
      'fecha': '1 de septiembre de 2026',
      'estado': 'En camino',
      'productos': 'Postre de capuchino, Postre de mora',
      'total': '\$26.000',
      'metodoPago': 'Efectivo',
    },
    {
      'numero': '#002',
      'fecha': '28 de agosto de 2026',
      'estado': 'Entregado',
      'productos': 'Torta de tres leches',
      'total': '\$26.000',
      'metodoPago': 'Tarjeta',
    },
    {
      'numero': '#003',
      'fecha': '25 de agosto de 2026',
      'estado': 'Entregado',
      'productos': 'Torta de café',
      'total': '\$55.000',
      'metodoPago': 'Efectivo',
    },
  ];

  // ============================================================
  // NOTIFICADOR
  // ============================================================

  static final ValueNotifier<int> cantidadPedidos = ValueNotifier<int>(
    pedidos.length,
  );

  // ============================================================
  // AGREGAR PEDIDO
  // ============================================================

  static void agregarPedido(Map<String, dynamic> pedido) {
    pedidos.insert(0, pedido);
    cantidadPedidos.value = pedidos.length;
  }

  // ============================================================
  // GENERAR NÚMERO DE PEDIDO
  // ============================================================

  static String siguienteNumero() {
    return '#${(pedidos.length + 1).toString().padLeft(3, '0')}';
  }
}
