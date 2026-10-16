
import 'package:flutter/material.dart';

import '../../../../core/config/app_colors.dart';

class PedidosFormatters {
  static String idCorto(String id) {
    if (id.isEmpty) return 'Sin ID';
    return id.length > 8 ? id.substring(id.length - 8) : id;
  }

  static String nombreEstado(String estado) {
    const nombres = {
      'todos': 'Todos',
      'pendiente': 'Pendiente',
      'en_cocina': 'En cocina',
      'listo': 'Listo',
      'servido': 'Servido',
      'pagado': 'Pagado',
      'cancelado': 'Cancelado',
    };
    return nombres[estado] ?? estado;
  }

  static Color colorEstado(String estado) {
    switch (estado) {
      case 'pendiente':
        return Colors.orange.shade800;
      case 'en_cocina':
        return Colors.deepOrange.shade700;
      case 'listo':
        return Colors.green.shade700;
      case 'servido':
        return Colors.teal.shade700;
      case 'pagado':
        return Colors.blueGrey.shade700;
      case 'cancelado':
        return Colors.red.shade700;
      default:
        return AppColors.cafeMedio;
    }
  }

  static String precio(num valor) {
    final entero = valor.round().toString();
    final buffer = StringBuffer();

    for (var i = 0; i < entero.length; i++) {
      buffer.write(entero[i]);
      final restantes = entero.length - i - 1;
      if (restantes > 0 && restantes % 3 == 0) {
        buffer.write('.');
      }
    }

    return '\$${buffer.toString()}';
  }

  static String fecha(DateTime? fecha) {
    if (fecha == null) return 'Fecha no disponible';

    final local = fecha.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${local.year} · $hora:$minuto';
  }
}
