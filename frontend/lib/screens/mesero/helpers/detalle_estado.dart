import 'package:flutter/material.dart';

String textoEstadoPedido(String estado) {
  switch (estado) {
    case 'pendiente':
      return 'Pendiente';
    case 'en_cocina':
      return 'En cocina';
    case 'listo':
      return 'Listo';
    case 'servido':
      return 'Entregado';
    case 'pagado':
      return 'Pagado';
    case 'cancelado':
      return 'Cancelado';
    default:
      return estado;
  }
}

Color colorEstadoPedido(String estado) {
  switch (estado) {
    case 'pendiente':
      return Colors.orange;
    case 'en_cocina':
      return Colors.deepOrange;
    case 'listo':
      return Colors.green;
    case 'servido':
      return Colors.blue;
    case 'pagado':
      return Colors.grey;
    case 'cancelado':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

IconData iconoEstadoPedido(String estado) {
  switch (estado) {
    case 'pendiente':
      return Icons.pending_actions;
    case 'en_cocina':
      return Icons.restaurant;
    case 'listo':
      return Icons.check_circle_outline;
    case 'servido':
      return Icons.room_service;
    case 'pagado':
      return Icons.payments_outlined;
    case 'cancelado':
      return Icons.cancel_outlined;
    default:
      return Icons.receipt_long;
  }
}